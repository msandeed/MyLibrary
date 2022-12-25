//
//  Models.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 27/07/2022.
//

import Foundation

struct ResourceMetaData {
    let path: String
    let parameters: [URLQueryItem]
    let isSecured: Bool
    
    internal init(path: String, parameters: [URLQueryItem] = [], isSecured: Bool = false) {
        self.path = path
        self.parameters = parameters
        self.isSecured = isSecured
    }
}

enum AccessToken: String {
    // Should get securely
    case production = "SomeToken"
    case staging = "AnotherToken"
}

enum NetworkError: Error {
    case requestError
//    case transportError(error: Error)
    case serverError(statusCode: Int)
    case internalError(statusCode: Int)
//    case sessionError(error: Error)
    case noData
    case decodingError(Error)
    case unknown
}

// Use if json object is wrapped inside a result property
//Don't forget to add .map(\.result) to URLSession's extension publisher
struct NetworkResponse<Wrapped: Decodable>: Decodable {
    var result: Wrapped
}

struct Endpoint<Kind: EndpointKind, Response: Decodable> {
    var path: String
    var queryItems = [URLQueryItem]()
}

extension Endpoint {
    func makeRequest(with data: Kind.RequestData) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        components.path = "/" + path
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        // If either the path or the query items passed contained
        // invalid characters, we'll get a nil URL back:
        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        Kind.prepare(&request, with: data)
        return request
    }
}

protocol EndpointKind {
    associatedtype RequestData
    
    static func prepare(_ request: inout URLRequest,
                        with data: RequestData)
}

enum EndpointKinds {
    enum Public: EndpointKind {
        static func prepare(_ request: inout URLRequest,
                            with _: Void) {
            // Here we can do things like assign a custom cache
            // policy for loading our publicly available data.
            // In this example we're telling URLSession not to
            // use any locally cached data for these requests:
            request.cachePolicy = .reloadIgnoringLocalCacheData
        }
    }

    enum Private: EndpointKind {
        static func prepare(_ request: inout URLRequest,
                            with token: AccessToken) {
            // For our private endpoints, we'll require an
            // access token to be passed, which we then use to
            // assign an Authorization header to each request:
            request.addValue("Bearer \(token.rawValue)",
                forHTTPHeaderField: "Authorization"
            )
        }
    }
}
