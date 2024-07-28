//
//  PopularMoviesViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 29.07.2024.
//

import Foundation

class PopularMoviesViewModel: BaseMoviesViewModel {
    override init() {
        super.init()
        configure(endpoint: .popularMovies, initialParameters: ["page": 1])
    }
}
