import Foundation

class PaginatedMoviesListViewModel: PaginatedMoviesListViewModelProtocol {
    private var movies: [Movie] = []
    private var genres: [Genre] = []
    private(set) var movieCellViewModels: [MovieTableViewCellViewModel] = []
    private var isFetching = false
    weak var delegate: MoviesTableViewModelDelegate?
    
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
        guard let sessionID = SessionManager.shared.sessionId else {
            self.delegate?.didFailToFetchMovies(with: NetworkService.NetworkServiceError.invalidSession)
            return
        }
        
        self.currentEndpoint = endpoint
        self.requestParameters = initialParameters.merging(["session_id": sessionID], uniquingKeysWith: { $1 })
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
        fetchMoviesAndGenres(page: 1) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didFetchMovies()
            case .failure(let error):
                self?.delegate?.didFailToFetchMovies(with: error)
            }
        }
    }
    
    func fetchNextPage() {
        fetchMoviesAndGenres(page: currentPage + 1) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didFetchMovies()
            case .failure(let error):
                self?.delegate?.didFailToFetchMovies(with: error)
            }
        }
    }
    
    func fetchMoviesAndGenres(page: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isFetching, let endpoint = currentEndpoint, page <= totalPages else { return }
        isFetching = true
        
        requestParameters["page"] = page
        
        DispatchQueue.global().async {
            let group = DispatchGroup()
            var fetchedGenres: [Genre] = []
            var fetchedMoviesPage: Movies?
            var fetchError: Error?
            
            group.enter()
            self.fetchGenres(from: .genreMovieList) { result in
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
                defer { group.leave() }
                
                switch result {
                case .success(let movies):
                    fetchedMoviesPage = movies
                case .failure(let error):
                    fetchError = error
                }
            }
            
            group.notify(queue: .main) {
                self.isFetching = false
                
                if let error = fetchError {
                    completion(.failure(error))
                    return
                }
                
                guard let moviesPage = fetchedMoviesPage else {
                    completion(.failure(NetworkService.NetworkServiceError.failedToGetData))
                    return
                }
                
                self.genres = fetchedGenres
                if page == 1 {
                    self.movies = moviesPage.results
                } else {
                    self.movies.append(contentsOf: moviesPage.results)
                }
                self.totalPages = moviesPage.totalPages
                self.currentPage = page
                self.combineData()
                completion(.success(()))
            }
        }
    }
    
    private func fetchGenres(from endpoint: Endpoint, completion: @escaping ((Result<Genres, Error>) -> Void)) {
        NetworkService.shared.execute(endpoint: endpoint, expecting: Genres.self) { result in
            completion(result)
        }
    }
    
    private func fetchMovies(from endpoint: Endpoint, with parameters: [String: Any], completion: @escaping ((Result<Movies, Error>) -> Void)) {
        NetworkService.shared.execute(endpoint: endpoint, parameters: parameters, expecting: Movies.self) { result in
            completion(result)
        }
    }
    
    private func combineData() {
        movieCellViewModels = movies.map { movie in
            MovieTableViewCellViewModel(
                title: movie.title,
                voteAverage: movie.voteAverage,
                releaseDate: movie.releaseDate,
                genreIDs: movie.genreIDS,
                genres: genres,
                posterPath: movie.posterPath,
                verdict: movie.rating ?? nil
            )
        }
        delegate?.didFetchMovies()
    }
    
    func movie(at index: Int) -> Movie? {
        return movies[index]
    }
    
    //    func updateParameters(parametrs: String) {
    //        updateRequestParameters(["sort_by": sortOrder])
    //    }
}
