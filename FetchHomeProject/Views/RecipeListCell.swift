//
//  RecipeListCell.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/14/25.
//

import SwiftUI

struct RecipeListCell: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(alignment: .top) {
            CachedImage(item: (name: recipe.id, url: recipe.photoURLLarge ?? ""), animation: .spring, transition: .scale.combined(with: .opacity)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 44, height: 44)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .clipShape(.buttonBorder)
                case .failure(_):
                    Image(systemName: "xmark")
                        .symbolVariant(.circle.fill)
                        .foregroundStyle(.red)
                        .frame(width: 80, height: 80)
                        .clipShape(.buttonBorder)
                        
                @unknown default:
                    EmptyView()
                }
                
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.title3)
                    .fontWeight(.medium)
                Text(recipe.cuisine)
            }
        }
    }
}

#Preview {
    RecipeListCell(recipe: .init(id: "599344f4-3c5c-4cca-b914-2210e3b3312f",
                                 name: "Apple & Blackberry Crumble",
                                 cuisine: "British",
                                 photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                                 photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                                 sourceURL: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                                 youtubeURL: "https://www.youtube.com/watch?v=4vhcOwVBDO4"))
}
