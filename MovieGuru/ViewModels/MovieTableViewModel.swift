//
//  WatchlistViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import Foundation

protocol MovieTableViewModelDelegate: AnyObject {
    func didFetchMovies()
}

class MovieTableViewModel {
    private var movies: [MovieSummary] = [] {
        didSet {
            cellViewModels = movies.map { MovieCellViewModel(movie: $0) }
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
    
    func fetchMovies(endpoint: Endpoint, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let (data, _) = try await APICaller.shared.performRequest(endpoint: endpoint)
                let movs = try JSONDecoder().decode(MoviesSummaryPage.self, from: data)
                self.movies = movs.results
                completion(.success(()))
            } catch {
                print("Error fetching movies: \(error)")
                completion(.failure(error))
            }
        }
    }
}
