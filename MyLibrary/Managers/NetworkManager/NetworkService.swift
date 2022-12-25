//
//  NetworkService.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 27/07/2022.
//

import Foundation
import Combine

protocol NetworkService {
    var urlSession: URLSession { get }
    func fetchData<D: Decodable>(for resource: D.Type, path: String, parameters: [URLQueryItem], isSecured: Bool) -> AnyPublisher<[D], NetworkError>
}

public struct DefaultNetworkService: NetworkService {
    var urlSession = URLSession.shared
    
    func fetchData<D: Decodable>(for resource: D.Type,
                                      path: String,
                                      parameters: [URLQueryItem] = [],
                                      isSecured: Bool = false) -> AnyPublisher<[D], NetworkError> {
        if isSecured {
            let endpoint = Endpoint<EndpointKinds.Private, [D]>(path: path, queryItems: parameters)
            return urlSession.publisher(for: endpoint, using: .staging) // Access Key should be altered by Env
        } else {
            let endpoint = Endpoint<EndpointKinds.Public, [D]>(path: path, queryItems: parameters)
            return urlSession.publisher(for: endpoint, using: Void())
        }
    }
}

// Currently not used. Would be used along with commented out URLSession extension (See Extensions)
extension DefaultNetworkService {
    private func resolveUrl(for resource: Urls) -> URL {
        URL(string: "https://" + baseUrl + "/" + resource.rawValue)!
    }
}
