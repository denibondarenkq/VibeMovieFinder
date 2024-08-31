import Foundation

class VibeListViewModel: MoviesListViewModelProtocol {
    private var movies: [Movie] = []
    private var genres: [Genre] = []
    private var watchedMoviesTitles: [String] = []
    private(set) var movieCellViewModels: [MovieTableViewCellViewModel] = []
    
    private let geminiService = GeminiService.shared
    weak var delegate: MoviesTableViewModelDelegate?

    private var requestParameters: [String: Any] = [:]
    
    var hasMorePages: Bool {
        return false
    }
    
    func fetchMoviesAndGenres(page: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        // This function is not needed in this class as movies will be fetched only based on vibes
    }
    
    func fetchMoviesBasedOnVibes(_ vibes: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let sessionID = SessionManager.shared.sessionId else {
            self.delegate?.didFailToFetchMovies(with: NetworkService.NetworkServiceError.invalidSession)
            return
        }
        
        self.requestParameters["session_id"] = sessionID
        
        fetchWatchedMovies { [weak self] in
            guard let self = self else { return }

            let prompt = self.createPrompt(vibes: vibes)
            
            self.geminiService.GenerateMovies(prompt: prompt) { result in
                switch result {
                case .success(let movieGeminis):
                    self.processMovieGeminiResponse(movieGeminis) { result in
                        switch result {
                        case .success:
                            self.fetchGenres { [weak self] result in
                                guard let self = self else { return }
                                switch result {
                                case .success(let fetchedGenres):
                                    self.genres = fetchedGenres.genres
                                    self.combineData()
                                    self.delegate?.didFetchMovies()
                                    completion(.success(()))
                                case .failure(let error):
                                    self.delegate?.didFailToFetchMovies(with: error)
                                    completion(.failure(error))
                                }
                            }
                        case .failure(let error):
                            self.delegate?.didFailToFetchMovies(with: error)
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    self.delegate?.didFailToFetchMovies(with: error)
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func fetchWatchedMovies(completion: @escaping () -> Void) {
        let endpoint = Endpoint.accountRatedMovies
        
        NetworkService.shared.execute(endpoint: endpoint, parameters: self.requestParameters, expecting: Movies.self) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.watchedMoviesTitles = movies.results.map { $0.title }
                completion()
            case .failure(let error):
                print("Failed to fetch watched movies: \(error)")
                completion()
            }
        }
    }
    
    private func createPrompt(vibes: [String]) -> String {
        let watchedMoviesList = watchedMoviesTitles.joined(separator: ", ")
        let vibesList = vibes.joined(separator: ", ")

        let promptObject: [String: Any] = [
            "prompt": "Generate a list of movie recommendations based on the following vibes: \(vibesList). Exclude the following movies from the recommendations: \(watchedMoviesList). Each movie should be presented as an object with 'title' and 'releaseYear' keys, where 'title' is the name of the movie and 'releaseYear' is the year of release. The output should be formatted as a JSON array with objects having these keys.",
            "format": "json"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: promptObject, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            fatalError("Failed to create JSON string for prompt")
        }
        
        return jsonString
    }
    
    private func processMovieGeminiResponse(_ movieGeminis: [MovieGemini], completion: @escaping (Result<Void, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var fetchedMovies: [Movie] = []
        var fetchError: Error?

        for movieGemini in movieGeminis {
            dispatchGroup.enter()
            let query = movieGemini.title
            let year = movieGemini.releaseYear
            
            // Создаем параметры для поиска фильма
            let parameters: [String: Any] = [
                "query": query,
                "primary_release_year": "\(year)"
            ]
            
            // Создаем эндпоинт поиска фильма
            let endpoint = Endpoint.searchMovie
            
            // Выполняем запрос
            NetworkService.shared.execute(endpoint: endpoint, parameters: parameters, expecting: Movies.self) { result in
                switch result {
                case .success(let movies):
                    if let firstMovie = movies.results.first {
                        fetchedMovies.append(firstMovie)
                    }
                case .failure(let error):
                    print(movieGemini, parameters)
//                    fetchError = error
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
                return
            }
            
            self.movies = fetchedMovies
            completion(.success(()))
        }
    }
    
    private func fetchGenres(completion: @escaping ((Result<Genres, Error>) -> Void)) {
        NetworkService.shared.execute(endpoint: .genreMovieList, expecting: Genres.self) { result in
            completion(result)
        }
    }
    
    private func combineData() {
        movieCellViewModels = movies.map { movie in
            let movieGenres = movie.genreIDS.compactMap { genreID in
                genres.first { $0.id == genreID }
            }
            
            return MovieTableViewCellViewModel(
                title: movie.title,
                voteAverage: movie.voteAverage,
                releaseDate: movie.releaseDate,
                genreIDs: movie.genreIDS,
                genres: movieGenres,
                posterPath: movie.posterPath
            )
        }
    }
    
    func fetchNextPage() {
        // Pagination is not used in this class
    }
    
    func movie(at index: Int) -> Movie? {
        return movies[index]
    }
}
