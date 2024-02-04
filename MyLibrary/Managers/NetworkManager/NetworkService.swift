//
//  NetworkService.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 27/07/2022.
//

import Foundation
import Combine

typealias DTO = Decodable & DomainConvertible

protocol NetworkService {
    var urlSession: URLSession { get }
    func executeRequest<D: DTO>(for _: D.Type, with metaData: ResourceMetaData) -> AnyPublisher<D.DomainObject, NetworkError>
}

public struct DefaultNetworkService: NetworkService {
    var urlSession = URLSession.shared
    
    func executeRequest<D: DTO>(for _: D.Type, with metaData: ResourceMetaData) -> AnyPublisher<D.DomainObject, NetworkError> {
        let endpoint = Endpoint<D>(path: metaData.path, queryItems: metaData.parameters, body: metaData.body, isSecure: metaData.isSecured)
        return urlSession.publisher(for: endpoint).map { $0.toDomain }.eraseToAnyPublisher()
    }
}

// MARK: - Helpers
protocol DomainConvertible {
    associatedtype DomainObject
    var toDomain: DomainObject { get }
}

extension Array: DomainConvertible where Element: DomainConvertible {
    var toDomain: [Element.DomainObject] {
        return self.map { $0.toDomain }
    }
}

// Currently not used. Would be used along with commented out URLSession extension (See Extensions)
extension DefaultNetworkService {
    private func resolveUrl(for resource: Urls) -> URL {
        URL(string: "https://" + baseUrl + "/" + resource.rawValue)!
    }
}
