//
//  RecipeDetailsView.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/15/25.
//

import SwiftUI

struct RecipeDetailsView: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                CachedImage(item: (name: recipe.id, url: recipe.photoURLLarge ?? ""), animation: .spring, transition: .scale.combined(with: .opacity)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 44, height: 44)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    case .failure(_):
                        Image(systemName: "xmark")
                            .symbolVariant(.circle.fill)
                            .foregroundStyle(.red)
                            .frame(width: 280, height: 280)
                            .clipShape(.buttonBorder)
                            
                    @unknown default:
                        EmptyView()
                    }
                    
                }
                
                Text(recipe.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                
                Text("Cuisine: \(recipe.cuisine)")
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                
                Divider()

                HStack(spacing: 16) {
                    if let url = recipe.youtubeURL, let youtubeURL = URL(string: url) {
                        Link(destination: youtubeURL) {
                            Label("Watch on YouTube", systemImage: "play.rectangle.fill")
                        }
                    }

                    if let url = recipe.sourceURL, let sourceURL = URL(string: url) {
                        Link(destination: sourceURL) {
                            Label("View Source", systemImage: "safari.fill")
                        }
                    }
                }
                .font(.body)
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
    }
}


#Preview {
    RecipeDetailsView(recipe: Recipe(id: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", name: "Apam Balik", cuisine: "Malaysian", photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", sourceURL: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg"))
}
