//
//  WatchlistViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import Foundation
import UIKit

protocol MovieTableViewModelDelegate: AnyObject {
    func didFetchMovies()
}
class MovieTableViewModel {
    private var movies: [MovieSummary] = [] {
        didSet {
            cellViewModels.removeAll()
            
            for movie in movies {
                let cellViewModel = MovieCellViewModel(movie: movie)
                cellViewModels.append(cellViewModel)
            }
            
            delegate?.didFetchMovies()
        }
    }
    
    
    public private(set) var cellViewModels: [MovieCellViewModel] = []
    weak var delegate: MovieTableViewModelDelegate?

    
    func numberOfMovies() -> Int {
        return movies.count
    }
    
    func movie(at index: Int) -> MovieSummary {
        return movies[index]
    }
    
    func fetchMovies(completion: @escaping (Result<Void, Error>) -> Void) {
            Task {
                do {
                    let (data, _) = try await APICaller.shared.performRequest(endpoint: .accountWatchList(accountId: 21250428, page: 1))
                    let movs = try JSONDecoder().decode(MoviesSummaryPage.self, from: data)
                    print(movs.results)
                    self.movies = movs.results
                    completion(.success(()))
                } catch {
                    print("Error fetching movies: \(error)")
                    completion(.failure(error))
                }
            }
        }


    
    
    
    //        movies = [
    //            Movie(name: "Фильм 1", rating: 8.5, year: 2020, duration: 120, image: UIImage(named: "oxxqiyWrnM0XPnBtVe9TgYWnPxT")!),
    //            Movie(name: "Фильм 2", rating: 7.9, year: 2019, duration: 105, image: UIImage(named: "sh7Rg8Er3tFcN9BpKIPOMvALgZd")!)
    //            // Добавьте больше фильмов по мере необходимости
    //        ]
    
    //        APICaller.shared.performRequest { [weak self] result in
    //            DispatchQueue.main.async {
    //                switch result {
    //                case .success(let playlists):
    //                    self?.playlists = playlists
    //                    self?.updateUI()
    //                case .failure(let error):
    //                    print(error.localizedDescription)
    //                }
    //            }
    //        }
}

