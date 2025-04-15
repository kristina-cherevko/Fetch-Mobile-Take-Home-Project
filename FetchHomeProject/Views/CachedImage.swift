//
//  CachedImage.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/14/25.
//

import SwiftUI

struct CachedImage<Content: View>: View {

    
    @StateObject private var manager = CachedImageManager()
    let item: (name: String, url: String)
    let animation: Animation?
    let transition: AnyTransition
    let content: (AsyncImagePhase) -> Content
    
    init(item: (name: String, url: String),
         animation: Animation? = nil,
         transition: AnyTransition = .identity,
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.item = item
        self.animation = animation
        self.transition = transition
        self.content = content
    }
    
    var body: some View {
        ZStack {
            switch manager.currentState {
            case .loading:
                content(.empty)
                    .transition(transition)
            case .failure(let error):
                content(.failure(error))
                    .transition(transition)
            case .success(let data):
                if let image = UIImage(data: data) {
                    content(.success(Image(uiImage: image)))
                        .transition(transition)
                } else {
                    content(.failure(CachedImageError.failedToDecodeImage))
                        .transition(transition)
                }
            default:
                content(.empty)
                    .transition(transition)
            }
        
        }
        .animation(animation, value: manager.currentState)
        .task {
            await manager.loadImage(item)
        }
    }
}

#Preview {
    CachedImage(item: (name: "599344f4-3c5c-4cca-b914-2210e3b3312f", url: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg")) { _ in
        EmptyView()
    }
}

extension CachedImage {
    enum CachedImageError: Error {
        case failedToDecodeImage
    }
}
