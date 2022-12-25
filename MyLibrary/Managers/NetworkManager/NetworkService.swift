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
    func fetchData<D: Decodable>(for resource: D.Type, with metaData: ResourceMetaData) -> AnyPublisher<D, NetworkError>
}

public struct DefaultNetworkService: NetworkService {
    var urlSession = URLSession.shared
    
    func fetchData<D: Decodable>(for resource: D.Type, with metaData: ResourceMetaData) -> AnyPublisher<D, NetworkError> {
        // Refactor this. Limitation in declaring generic type EndpointKind
        if metaData.isSecured {
            let endpoint = Endpoint<EndpointKinds.Private, D>(path: metaData.path, queryItems: metaData.parameters)
            return urlSession.publisher(for: endpoint, using: .staging) // Access Key should be altered by Env
        } else {
            let endpoint = Endpoint<EndpointKinds.Public, D>(path: metaData.path, queryItems: metaData.parameters)
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
