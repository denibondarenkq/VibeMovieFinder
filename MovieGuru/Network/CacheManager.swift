//
//  CacheManager.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 20.07.2024.
//

import Foundation


final class CacheManager {
    static let shared = CacheManager()
    
    private init() {}
    
    private var cache: [URL: Data] = [:]
    private let maxCacheSize = 100 
    
    func cachedResponse(for endpoint: Endpoint) -> Data? {
        return cache[endpoint.url]
    }
    
    func cacheResponse(_ data: Data, for endpoint: Endpoint) {
        if cache.count >= maxCacheSize {
            if let oldestKey = cache.keys.first {
                cache.removeValue(forKey: oldestKey)
            }
        }
        cache[endpoint.url] = data
    }

    
    func clearCache() {
        cache.removeAll()
    }
}
