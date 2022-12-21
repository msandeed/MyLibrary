//
//  NetworkManager.swift
//  Books-SwiftUIwMVVM
//
//  Created by Mostafa Sandeed on 27/07/2022.
//

import Foundation
import Combine

public struct NetworkManager {
    let urlSession = URLSession.shared
    
    func fetchBooks() -> AnyPublisher<[Book.RawBook], NetworkError> {
//        urlSession.publisher(for: resolveUrl(for: .books))
        
        let endpoint = Endpoint<EndpointKinds.Public, [Book.RawBook]>(path: Urls.books.rawValue)
        return urlSession.publisher(for: endpoint, using: Void())
    }
}

extension NetworkManager {
    private func resolveUrl(for resource: Urls) -> URL {
        URL(string: "https://" + baseUrl + "/" + resource.rawValue)!
    }
}
