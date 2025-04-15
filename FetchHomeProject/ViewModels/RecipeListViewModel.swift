//
//  RecipeListViewModel.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/14/25.
//

import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var isEmpty: Bool = false
    @Published var errorMessage: String?
    @Published var isShowingError: Bool = false
    private let recipesService: RecipesServiceProtocol
    
    init(recipesService: RecipesServiceProtocol = RecipesService()) {
        self.recipesService = recipesService
    }
    
    func fetchRecipes() async {
        self.isLoading = true
        defer { self.isLoading = false }
        do {
            let response = try await recipesService.fetchRecipes()
            if response.recipes.isEmpty {
                self.isEmpty = true
            } else {
                self.recipes = response.recipes
                self.isEmpty = false
            }
        } catch {
            isShowingError = true
            if let error = error as? NetworkError {
                switch error {
                case .invalidURL:
                    errorMessage = "Invalid URL. Please contact support."
                case .requestFailed:
                    errorMessage = "Network request failed. Check your connection."
                case .badResponse(let statusCode):
                    errorMessage = "Server error: \(statusCode). Try again later."
                case .malformedData:
                    errorMessage = "We couldn't load your recipes. Try again later."
                }
            } else {
                errorMessage = "An unknown error occurred."
            }
        }
        
    }
}
