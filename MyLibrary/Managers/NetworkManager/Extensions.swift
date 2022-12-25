//
//  Extensions.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 27/07/2022.
//

import Foundation
import Combine

// Generic Response
// Receives url
extension URLSession {
//    func publisher<T: Decodable>(
//        for url: URL,
//        decoder: JSONDecoder = .init()
//    ) -> AnyPublisher<T, NetworkError> {
//        dataTaskPublisher(for: url)
//            .mapError { error -> NetworkError in
//                NetworkError.sessionError(error: error)
//            }
//            .map { $0.data }
//            .decode(type: T.self, decoder: decoder)
//            .mapError { error -> NetworkError in
//                NetworkError.decodingError(error)
//            }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
}


// Generic Response
// Receives Endpoint object from which it determines EndpointType, extracts the request data (access token for instance) and creates the request
extension URLSession {
    func publisher<K, R>(
        for endpoint: Endpoint<K, R>,
        using requestData: K.RequestData,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<R, NetworkError> {
        guard let request = endpoint.makeRequest(with: requestData) else {
            return Fail(
                error: NetworkError.requestError
            ).eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: request)
            .tryMap { data, response in
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    if (400...499).contains(response.statusCode) {
                        throw NetworkError.internalError(statusCode: response.statusCode)
                    } else {
                        throw NetworkError.serverError(statusCode: response.statusCode)
                    }
                }
                
                guard !data.isEmpty else {
                    throw NetworkError.noData
                }
                
                return data
            }
            .decode(type: R.self, decoder: decoder)
            .mapError { error in
                switch error {
                case is Swift.DecodingError:
                    return NetworkError.decodingError(error)
                default:
                    return error as? NetworkError ?? NetworkError.unknown
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
