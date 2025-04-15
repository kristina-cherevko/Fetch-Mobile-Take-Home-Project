//
//  NetworkClient.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/14/25.
//

import Foundation
import UIKit

protocol NetworkClientProtocol {
    func sentRequest<T: Decodable>(to endpoint: Endpoint, responseType: T.Type) async throws -> T
        
}

final class NetworkClient: NetworkClientProtocol {
    func sentRequest<T: Decodable>(to endpoint: Endpoint, responseType: T.Type) async throws -> T {
        guard let request = endpoint.urlRequest else {
            throw NetworkError.invalidURL
        }
        
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.requestFailed(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        do {
            return try JSONDecoder().decode(responseType.self, from: data)
        } catch {
            throw NetworkError.malformedData
        }
    }
}
