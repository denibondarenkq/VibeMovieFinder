//
//  AuthManager.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 05.07.2024.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    var token: String? {
        return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZWM5ODQ4ODQ0MWZiNzc3NDFhMjI5YjUzNDRkZGE4YSIsIm5iZiI6MTcyMDAyNTY4NC4zOTMyODEsInN1YiI6IjY2MzU2YTkwYWQ1OWI1MDEyMjZlMDJlYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Ek0VihWUtm3hTKiSFV9RCdq5mRZPcqcYdLyOdthmiFo"
    }
    
    var accountId: Int {
        return 21250428
    }
    
    func withValidToken(completion: @escaping (String) -> Void) {
        if let token = token {
            completion(token)
        } else {
        }
    }
}
