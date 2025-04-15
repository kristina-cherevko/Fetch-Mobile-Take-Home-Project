//
//  Recipe.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/14/25.
//

struct RecipeListResponse: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let cuisine: String
    let photoURLLarge: String?
    let photoURLSmall: String?
    let sourceURL: String?
    let youtubeURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    
}
