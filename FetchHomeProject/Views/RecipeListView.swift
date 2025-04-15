//
//  ContentView.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/14/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Recipes")
                } else if viewModel.isEmpty {
                  ContentUnavailableView("No recipes found", systemImage: "exclamationmark.triangle")
                } else {
                    List(viewModel.recipes, id: \.id) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeListCell(recipe: recipe)
                                .toolbarRole(.editor)
                        }
                    }
                    .refreshable {
                        await viewModel.fetchRecipes()
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("📖 Recipes")
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailsView(recipe: recipe)
            }
        }
        .tint(.black)
        .task {
            await viewModel.fetchRecipes()
        }
        .alert("Error", isPresented: $viewModel.isShowingError, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(viewModel.errorMessage ?? "Something went wrong.")
        })
    }
}

#Preview {
    RecipeListView()
}
