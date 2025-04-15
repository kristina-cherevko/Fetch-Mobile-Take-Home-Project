//
//  Endpoint.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/14/25.
//

import Foundation
// Protocol defining the structure of an API endpoint.
protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

// Default implementations for `Endpoint` protocol properties and computed property urlRequest
extension Endpoint {
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var body: [String: Any]? {
        return nil
    }
    
    var queryItems: [String: Any]? {
        return nil
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var urlRequest: URLRequest? {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)

        if let queryItems = queryItems {
            components?.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        guard let url = components?.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        if let body = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        return request
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case badResponse(statusCode: Int)
    case malformedData
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .badResponse(let statusCode):
            return "Bad response with code \(statusCode)"
        case .malformedData:
            return "Malformed response data"
        }
    }
}
