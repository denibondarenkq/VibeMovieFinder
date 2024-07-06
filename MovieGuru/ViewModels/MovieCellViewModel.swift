//
//  WatchlistTableViewCellModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import UIKit

struct MovieCellViewModel: Equatable {

    private let movie: MovieSummary
    private let genres: [Genre]

    init(movie: MovieSummary, genres: [Genre]) {
        self.movie = movie
        self.genres = genres
    }
    public var name: String {
        return movie.originalTitle
    }

    public var rating: String {
        return String(format: "%.1f", movie.voteAverage)
    }
    
    public var year: String {
        return String(movie.releaseDate.prefix(4))
    }
    
    public var genreNames: [String] {
            return movie.genreIDS.compactMap { id in
                genres.first(where: { $0.id == id })?.name
            }
        }
    
    public var posterURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
    }

    static func == (lhs: MovieCellViewModel, rhs: MovieCellViewModel) -> Bool {
        return lhs.movie.id == rhs.movie.id
    }
}
