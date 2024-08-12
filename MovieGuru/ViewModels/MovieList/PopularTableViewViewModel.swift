//
//  PopularMoviesViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 29.07.2024.
//

import Foundation

class PopularTableViewViewModel: MoviesTableViewViewModel {
    override init() {
        super.init()
        configure(endpoint: .moviePopular, initialParameters: ["page": 1, ])
    }
}
