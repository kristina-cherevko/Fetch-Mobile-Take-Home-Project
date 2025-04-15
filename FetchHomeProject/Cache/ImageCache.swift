//
//  ImageCacheManager.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/14/25.
//

import Foundation
import UIKit

class ImageCache {
    typealias CacheType = NSCache<NSString, NSData>
        
    static let shared = ImageCache()
    
    private init() {}
    
    private lazy var memoryCache: CacheType = {
        let cache = CacheType()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 52428800 Bytes > 50MB
        return cache
    }()
    
    func object(forkey key: NSString) -> Data? {
        memoryCache.object(forKey: key) as? Data
    }
    
    func set(object: NSData, forKey key: NSString) {
        memoryCache.setObject(object, forKey: key)
    }
    
    func removeAllObjects() {
        memoryCache.removeAllObjects()
    }
}
