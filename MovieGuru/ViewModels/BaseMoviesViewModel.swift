//
//  WatchlistViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import Foundation

protocol BaseMoviesViewModelDelegate: AnyObject {
    func didFetchedMovies()
}

class BaseMoviesViewModel {
    private var movies: [MovieSummary] = []
    private var genres: [Genre] = []
    private(set) var movieCellViewModels: [MovieTableCellViewModel] = []
    private var isFetching = false
    weak var delegate: BaseMoviesViewModelDelegate?
    
    private var currentEndpoint: Endpoint?
    private var requestParameters: [String: Any] = ["page": 1]
    private var currentPage: Int {
        get { requestParameters["page"] as? Int ?? 1 }
        set { requestParameters["page"] = newValue }
    }
    private var totalPages: Int = 1
    
    var hasMorePages: Bool {
        return currentPage < totalPages
    }
    
    func configure(endpoint: Endpoint, initialParameters: [String: Any] = [:]) {
        self.currentEndpoint = endpoint
        self.requestParameters = initialParameters
        resetData()
    }
    
    private func resetData() {
        movies = []
        genres = []
        movieCellViewModels = []
        currentPage = 1
        totalPages = 1
    }
    
    func updateRequestParameters(_ newParameters: [String: Any]) {
        for (key, value) in newParameters {
            requestParameters[key] = value
        }
        resetData()
        fetchMoviesAndGenres(page: 1)
    }
    
    func fetchMoviesAndGenres(page: Int) {
        guard !isFetching, let endpoint = currentEndpoint, page <= totalPages else { return }
        isFetching = true
        
        requestParameters["page"] = page
        
        DispatchQueue.global().async {
            let group = DispatchGroup()
            var fetchedGenres: [Genre] = []
            var fetchedMoviesPage: MoviesSummaryPage?
            var fetchError: Error?
            
            group.enter()
            self.fetchGenres(from: .genresMovieList) { result in
                switch result {
                case .success(let genres):
                    fetchedGenres = genres.genres
                case .failure(let error):
                    fetchError = error
                }
                group.leave()
            }
            
            group.enter()
            self.fetchMovies(from: endpoint, with: self.requestParameters) { result in
                switch result {
                case .success(let movies):
                    fetchedMoviesPage = movies
                case .failure(let error):
                    fetchError = error
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                guard fetchError == nil else {
                    self.isFetching = false
                    return
                }
                self.genres = fetchedGenres
                self.movies.append(contentsOf: fetchedMoviesPage!.results)
                self.totalPages = fetchedMoviesPage!.totalPages
                self.currentPage = page
                self.combineData()
                self.isFetching = false
            }
        }
    }
    
    func fetchNextPage() {
        fetchMoviesAndGenres(page: currentPage + 1)
    }
    
    private func fetchGenres(from endpoint: Endpoint, completion: @escaping ((Result<Genres, Error>) -> Void)) {
        DispatchQueue.global().async {
            NetworkService.shared.execute(endpoint: endpoint, expecting: Genres.self) { result in
                completion(result)
            }
        }
    }
    
    private func fetchMovies(from endpoint: Endpoint, with parameters: [String: Any], completion: @escaping ((Result<MoviesSummaryPage, Error>) -> Void)) {
        NetworkService.shared.execute(endpoint: endpoint, parameters: parameters, expecting: MoviesSummaryPage.self) { result in
            completion(result)
        }
    }
    
    private func combineData() {
        movieCellViewModels = movies.map { MovieTableCellViewModel(movie: $0, genres: genres) }
        delegate?.didFetchedMovies()
    }
        
    func movie(at index: Int) -> MovieSummary {
        return movies[index]
    }
}
