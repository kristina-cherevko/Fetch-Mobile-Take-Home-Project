//
//  RecipesEndpoint.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/14/25.
//

import Foundation


enum RecipesEndpoint: Endpoint {
    case allRecipes
    case malformedRecipes
    case emptyRecipes
    
    var baseURL: URL {
        return URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net")!
    }
    
    var path: String {
        switch self {
        case .allRecipes:
            return "/recipes.json"
        case .malformedRecipes:
            return "/recipes-malformed.json"
        case .emptyRecipes:
            return "/recipes-empty.json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}
