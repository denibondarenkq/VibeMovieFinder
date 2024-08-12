//
//  Genres.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 06.07.2024.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
}

struct Genres: Codable {
    let genres: [Genre]
}
