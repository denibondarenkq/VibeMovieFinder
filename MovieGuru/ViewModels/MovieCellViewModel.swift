//
//  WatchlistTableViewCellModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import UIKit

struct MovieCellViewModel: Equatable {

    private let movie: MovieSummary

    init(movie: MovieSummary) {
        self.movie = movie
    }

    public var name: String {
        return movie.originalTitle
    }

    public var rating: Double {
        return movie.voteAverage
    }
    
    public var year: String {
        return movie.releaseDate
    }
    
    public var duration: Int {
        return movie.voteCount
    }
    
    public var image: UIImage? {
           return UIImage(named: "oxxqiyWrnM0XPnBtVe9TgYWnPxT")
       }
    
    static func == (lhs: MovieCellViewModel, rhs: MovieCellViewModel) -> Bool {
        return lhs.name == rhs.name
    }

//    func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//        hasher.combine(location.id)
//        hasher.combine(dimension)
//        hasher.combine(type)
//    }
}
