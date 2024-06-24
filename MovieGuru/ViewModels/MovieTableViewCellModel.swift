//
//  WatchlistTableViewCellModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import UIKit

struct MovieTableViewCellModel: Equatable {

    private let movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }

    public var name: String {
        return movie.name
    }

    public var rating: Double {
        return movie.rating
    }
    
    public var year: Int {
        return movie.year
    }
    
    public var duration: Int {
        return movie.duration
    }
    
    public var image: UIImage? {
           return movie.image
       }
    
    static func == (lhs: MovieTableViewCellModel, rhs: MovieTableViewCellModel) -> Bool {
        return lhs.name == rhs.name
    }

//    func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//        hasher.combine(location.id)
//        hasher.combine(dimension)
//        hasher.combine(type)
//    }
}
