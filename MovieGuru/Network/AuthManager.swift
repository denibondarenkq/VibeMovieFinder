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
        return "eyJhbGciOiJIUzI1NiJ9......."
    }
    
    func withValidToken(completion: @escaping (String) -> Void) {
            // Проверяем и обновляем токен при необходимости
            if let token = token {
                completion(token)
            } else {
                // Обрабатываем случай, когда токен отсутствует или его нужно обновить
                // обновите токен и вызовите completion
            }
        }
}
