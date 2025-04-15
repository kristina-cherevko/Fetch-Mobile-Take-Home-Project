//
//  ImageLoader.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/14/25.
//

import Foundation

final class ImageLoader {
    func loadImage(from imgURLString: String) async throws -> Data {
        guard let url = URL(string: imgURLString) else {
            throw NetworkError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

