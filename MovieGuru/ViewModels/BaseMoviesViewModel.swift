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
        Task {
            do {
                let fetchedGenres = try await fetchGenres(from: .genresMovieList)
                let moviesPage = try await fetchMovies(from: endpoint, with: requestParameters)
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
        fetchMoviesAndGenres(page: currentPage + 1)
    }
    
    private func fetchGenres(from endpoint: Endpoint) async throws -> [Genre] {
        let response: Genres = try await APICaller.shared.execute(endpoint: endpoint, expecting: Genres.self)
        return response.genres
    }
    
    private func fetchMovies(from endpoint: Endpoint, with parameters: [String: Any]) async throws -> MoviesSummaryPage {
        let response: MoviesSummaryPage = try await APICaller.shared.execute(endpoint: endpoint, parameters: parameters, expecting: MoviesSummaryPage.self)
        return response
    }
    
    private func combineData() {
        movieCellViewModels = movies.map { MovieTableCellViewModel(movie: $0, genres: genres) }
        delegate?.didFetchMovies()
    }
        
    func movie(at index: Int) -> MovieSummary {
        return movies[index]
    }
}
