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
    let body: Encodable?
    let isSecured: Bool
    
    internal init(path: String, parameters: [String: String?] = [:], body: Encodable? = nil, isSecured: Bool = false) {
        self.path = path
        self.parameters = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        self.body = body
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

struct Endpoint<Response: Decodable> {
    var path: String
    var queryItems = [URLQueryItem]()
    var body: Encodable?
    var isSecure: Bool = false
}

extension Endpoint {
    func makeRequest() -> URLRequest? {
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
        // Add token if secured
        if isSecure {
            request.addValue("Bearer \(AccessToken.staging.rawValue)",
                forHTTPHeaderField: "Authorization"
            )   // Should secure token
        }
        // Post request
        if let requestBody = body {
            request.httpMethod = "POST"
            request.httpBody = try? JSONEncoder().encode(requestBody)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
//        Kind.prepare(&request, with: data)
        return request
    }
}
//
//protocol EndpointKind {
//    associatedtype RequestData
//    
//    static func prepare(_ request: inout URLRequest,
//                        with data: RequestData)
//}
//
//enum EndpointKinds {
//    enum Public: EndpointKind {
//        static func prepare(_ request: inout URLRequest,
//                            with _: Void) {
//            // Here we can do things like assign a custom cache
//            // policy for loading our publicly available data.
//            // In this example we're telling URLSession not to
//            // use any locally cached data for these requests:
////            request.cachePolicy = .reloadIgnoringLocalCacheData
//            
//            addHeader(&request)
//        }
//    }
//
//    enum Private: EndpointKind {
//        static func prepare(_ request: inout URLRequest,
//                            with token: AccessToken) {
//            // Add token
//            request.addValue("Bearer \(token.rawValue)",
//                forHTTPHeaderField: "Authorization"
//            )
//            addHeader(&request)
//        }
//    }
//    
//    static func addHeader(_ request: inout URLRequest) {
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    }
//}
