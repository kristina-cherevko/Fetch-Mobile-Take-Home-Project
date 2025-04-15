//
//  RecipesService.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/14/25.
//

protocol RecipesServiceProtocol {
    func fetchRecipes() async throws -> RecipeListResponse
    func fetchRecipes(from endpoint: RecipesEndpoint) async throws -> RecipeListResponse
}

class RecipesService: RecipesServiceProtocol {
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchRecipes() async throws -> RecipeListResponse {
        #if DEBUG
        print("Fetching recipes from API")
        #endif
        return try await networkClient.sentRequest(to: RecipesEndpoint.allRecipes, responseType: RecipeListResponse.self)
    }
    
    func fetchRecipes(from endpoint: RecipesEndpoint) async throws -> RecipeListResponse {
        return try await networkClient.sentRequest(to: endpoint, responseType: RecipeListResponse.self)
    }
}
