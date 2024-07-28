//
//  WatchlistViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import Foundation

protocol BaseMoviesViewModelDelegate: AnyObject {
    func didFetchMovies()
}

class BaseMoviesViewModel {
    private var movies: [MovieSummary] = []
    private var genres: [Genre] = []
    private(set) var cellViewModels: [MovieCellViewModel] = []
    private var isFetching = false
    weak var delegate: BaseMoviesViewModelDelegate?
    
    private var currentEndpoint: Endpoint?
    private var parameters: [String: Any] = ["page": 1]
    private var currentPage: Int {
        get { parameters["page"] as? Int ?? 1 }
        set { parameters["page"] = newValue }
    }
    private var totalPages: Int = 1
    
    func configure(endpoint: Endpoint, initialParameters: [String: Any] = [:]) {
        self.currentEndpoint = endpoint
        self.parameters = initialParameters
        resetData()
    }
    
    private func resetData() {
        movies = []
        genres = []
        cellViewModels = []
        currentPage = 1
        totalPages = 1
    }
    
    func updateParameters(_ newParameters: [String: Any]) {
        for (key, value) in newParameters {
            parameters[key] = value
        }
        resetData()
        fetchGenresAndMovies(page: 1)
    }
    
    func fetchGenresAndMovies(page: Int) {
        guard !isFetching, let endpoint = currentEndpoint, page <= totalPages else { return }
        isFetching = true
        
        parameters["page"] = page
        Task {
            do {
                let fetchedGenres = try await fetchGenres(endpoint: .genresMovieList)
                let moviesPage = try await fetchMovies(endpoint: endpoint, parameters: parameters)
                let newMovies = moviesPage.results
                
                DispatchQueue.main.async {
                    self.genres = fetchedGenres
                    self.movies.append(contentsOf: newMovies)
                    self.totalPages = moviesPage.totalPages
                    self.currentPage = page
                    self.combineData()
                    self.isFetching = false
                }
            } catch {
                print("Error fetching data: \(error)")
                DispatchQueue.main.async {
                    self.isFetching = false
                }
            }
        }
    }
    
    func fetchNextPage() {
        fetchGenresAndMovies(page: currentPage + 1)
    }
    
    private func fetchGenres(endpoint: Endpoint) async throws -> [Genre] {
        let response: Genres = try await APICaller.shared.execute(endpoint: endpoint, expecting: Genres.self)
        return response.genres
    }
    
    private func fetchMovies(endpoint: Endpoint, parameters: [String: Any]) async throws -> MoviesSummaryPage {
        let response: MoviesSummaryPage = try await APICaller.shared.execute(endpoint: endpoint, parameters: parameters, expecting: MoviesSummaryPage.self)
        return response
    }
    
    private func combineData() {
        cellViewModels = movies.map { MovieCellViewModel(movie: $0, genres: genres) }
        delegate?.didFetchMovies()
    }
    
    func numberOfMovies() -> Int {
        return cellViewModels.count
    }
    
    func movie(at index: Int) -> MovieSummary {
        return movies[index]
    }
}
