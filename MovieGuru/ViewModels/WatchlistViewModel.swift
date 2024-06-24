//
//  WatchlistViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import Foundation
import UIKit
class WatchlistTableViewModel {
    private var movies: [Movie] = [] {
        didSet {
            for movie in movies {
                let cellViewModel = MovieTableViewCellModel(movie: movie)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    public private(set) var cellViewModels: [MovieTableViewCellModel] = []

    func numberOfMovies() -> Int {
        return movies.count
    }

    func movie(at index: Int) -> Movie {
        return movies[index]
    }

    func fetchMovies() {
        // В реальном приложении здесь будет логика загрузки данных (например, из сети или базы данных)
        // Временно добавим случайные данные для тестирования
        movies = [
            Movie(name: "Фильм 1", rating: 8.5, year: 2020, duration: 120, image: UIImage(named: "oxxqiyWrnM0XPnBtVe9TgYWnPxT")!),
            Movie(name: "Фильм 2", rating: 7.9, year: 2019, duration: 105, image: UIImage(named: "sh7Rg8Er3tFcN9BpKIPOMvALgZd")!)
            // Добавьте больше фильмов по мере необходимости
        ]
    }
}
