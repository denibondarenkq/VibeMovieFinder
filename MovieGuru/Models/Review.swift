//
//  Reviews.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 10.08.2024.
//

import Foundation

struct Reviews {
    let id, page: Int
    let results: [Review]
    let totalPages, totalResults: Int
}

struct Review {
    let author: String
    let authorDetails: AuthorDetails
    let content, createdAt, id, updatedAt: String
    let url: String
}

struct AuthorDetails {
    let name, username: String
    let avatarPath: String?
    let rating: Int
}
