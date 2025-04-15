//
//  CachedImageManager.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/15/25.
//

import Foundation

final class CachedImageManager: ObservableObject {
    @Published private(set) var currentState: CurrentState?
    
    private let imageLoader = ImageLoader()
    
    @MainActor
    func loadImage(_ item: (name: String, url: String), cache: ImageCache = .shared) async {
        /*
         1. Check if the image is in memory: if it is -> return that image, If not -> check on disk
         2. Check if the image is on disk: If it is -> return the image and store it in memory for later, If not -> start the process to download the image
         3. Try to fetch the image -> Store it on disk and in memory for later
         */
        if let imageData = cache.object(forkey: item.name as NSString) {
            self.currentState = .success(data: imageData)
            #if DEBUG
            print("Fetching image from cache: \(item.name)")
            #endif
            return
        }
        if let diskCacheItem = FileStorageManager.shared.retrieve(with: item.name) {
            #if DEBUG
            print("Storing image in memory from disk: \(diskCacheItem.name)")
            #endif
            cache.set(object: diskCacheItem.data as NSData, forKey: diskCacheItem.name as NSString)
            self.currentState = .success(data: diskCacheItem.data)
            
            return
        }
        self.currentState = .loading
        do {
            let data = try await imageLoader.loadImage(from: item.url)
            self.currentState = .success(data: data)
            cache.set(object: data as NSData, forKey: item.name as NSString)
            FileStorageManager.shared.save(.init(name: item.name, data: data))
            #if DEBUG
            print("Caching image: \(item.url)")
            #endif
        } catch {
            self.currentState = .failure(error: error)
        }
        
    }
}

extension CachedImageManager {
    enum CurrentState: Equatable {
        case loading
        case failure(error: Error)
        case success(data: Data)
        
        static func == (lhs: CachedImageManager.CurrentState, rhs: CachedImageManager.CurrentState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.failure(let lhsError), .failure(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            case (.success(let lhsData), .success(let rhsData)):
                return lhsData == rhsData
            default:
                return false
            }
        }
    }
    
}
