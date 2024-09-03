import Foundation

protocol MovieDetailSectionsViewViewModelDelegate: AnyObject {
    func didFetchMovieDetails()
    func didUpdateMovieState()
    func didFailToFetch(with error: Error)
}

class MovieDetailSectionsViewViewModel {
    let movie: Movie
    private var genres: [Genre] = []
    private var credits: [Cast] = []
    private var images: [Backdrop] = []
    private var reviews: [Review] = []
    private var recommendations: [Movie] = []
    var movieAccountState: MovieAccountState?
    
    weak var delegate: MovieDetailSectionsViewViewModelDelegate?
    
    enum SectionType {
        case backdrop(viewModel: BackdropCollectionViewCellViewModel)
        case facts(viewModels: [FactCollectionViewCellViewModel])
        case overview(viewModels: [OverviewCollectionViewCellViewModel])
        case images(viewModels: [ImageCollectionViewCellViewModel])
        case genres(viewModels: [GenreCollectionViewCellViewModel])
        case cast(viewModels: [CastCollectionViewCellViewModel])
        case reviews(viewModels: [ReviewCollectionViewCellViewModel])
        case recommendations(viewModels: [MovieCollectionViewCellViewModel])
    }
    
    public private(set) var sections: [SectionType] = []
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    public var title: String {
        movie.title
    }
    
    var isRated: Bool {
        switch movieAccountState?.rated {
        case .rated(let rated):
            return true
        case .unrated(_):
            return false
        case .none:
            return false
        }
    }

    var userRating: Int? {
        switch movieAccountState?.rated {
        case .rated(let rated):
            return rated.value
        case .unrated(_), .none:
            return nil
        }
    }

    var isInWatchlist: Bool {
        return movieAccountState?.watchlist ?? false
    }
    
    public func fetchContent() {
        let dispatchGroup = DispatchGroup()
        var fetchError: Error?
        
        dispatchGroup.enter()
        fetchMovieAccountState { result in
            switch result {
            case .success(let state):
                self.movieAccountState = state
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchGenres { result in
            switch result {
            case .success(let genres):
                self.genres = genres.genres
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchCredits { result in
            switch result {
            case .success(let credits):
                self.credits = credits.cast
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchImages { result in
            switch result {
            case .success(let images):
                self.images = images.backdrops
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchReviews { result in
            switch result {
            case .success(let reviews):
                self.reviews = reviews.results
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchRecommendations { result in
            switch result {
            case .success(let recommendations):
                self.recommendations = recommendations.results
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if fetchError != nil {
                print("ERROR")
            }
            self.setUpSections()
            self.delegate?.didFetchMovieDetails()
        }
    }
    
    private func setUpSections() {
        sections = [
            .backdrop(viewModel: BackdropCollectionViewCellViewModel(imageUrl: movie.backdropPath)),
            .facts(viewModels: [
                FactCollectionViewCellViewModel(title: "Release", value: String(movie.releaseDate.prefix(7)), emoji: "🎬"),
                FactCollectionViewCellViewModel(title: "Rating", value: "\(round(movie.voteAverage * 10) / 10.0)/10", emoji: "🔥"),
                FactCollectionViewCellViewModel(title: "Your verdict", value: "\((userRating ?? -1) > -1 ? "\(userRating ?? 0)/10" : "Not rated")", emoji: "🧑‍⚖️"),
                FactCollectionViewCellViewModel(title: "Popularity", value: "\(round(movie.popularity * 10) / 10.0)", emoji: "🤩"),
                FactCollectionViewCellViewModel(title: "Language", value: movie.originalLanguage.uppercased(), emoji: "🌎"),
            ]),
            .images(viewModels: images.compactMap { image in
                ImageCollectionViewCellViewModel(
                    imagePath: image.filePath,
                    aspectRatio: image.aspectRatio
                )
            }),
            .overview(viewModels: [
                OverviewCollectionViewCellViewModel(titleLabel: "Description", descriptionText: movie.overview)
            ]),
            .cast(viewModels: credits.compactMap { cast in
                CastCollectionViewCellViewModel(
                    name: cast.name,
                    character: cast.character,
                    job: cast.job, imageUrl:
                        cast.profilePath)
            }),
            .genres(viewModels: movie.genreIDS.compactMap { id in
                if let genreName = genres.first(where: { $0.id == id })?.name {
                    return GenreCollectionViewCellViewModel(name: genreName)
                }
                return nil
            }),
        
            .reviews(viewModels: reviews.compactMap { review in
                ReviewCollectionViewCellViewModel(
                    author: review.author,
                    authorUsername: review.authorDetails.username,
                    rating: review.authorDetails.rating,
                    createdAt: review.createdAt,
                    content: review.content
                )
            }),
            .recommendations(viewModels: recommendations.compactMap { movie in
                MovieCollectionViewCellViewModel(
                    title: movie.title,
                    posterPath: movie.posterPath
                )
            })
        ]
    }
    
    func fetchMovieAccountState(completion: @escaping (Result<MovieAccountState, Error>) -> Void) {
        guard let sessionID = SessionManager.shared.sessionId else {
            completion(.failure(NetworkService.NetworkServiceError.invalidSession))
            return
        }
                
        let endpoint = Endpoint.movieAccountStates(movieId: movie.id)
        NetworkService.shared.execute(endpoint: endpoint, parameters: ["session_id": sessionID], expecting: MovieAccountState.self, completion: completion)
    }
    
    private func fetchGenres(completion: @escaping (Result<Genres, Error>) -> Void) {
        NetworkService.shared.execute(endpoint: .genreMovieList, expecting: Genres.self, completion: completion)
    }
    
    private func fetchCredits(completion: @escaping (Result<Credits, Error>) -> Void) {
        let endpoint = Endpoint.movieCredits(movieId: movie.id)
        NetworkService.shared.execute(endpoint: endpoint, expecting: Credits.self, completion: completion)
    }
    
    private func fetchImages(completion: @escaping (Result<Images, Error>) -> Void) {
        let endpoint = Endpoint.movieImages(movieId: movie.id)
        NetworkService.shared.execute(endpoint: endpoint, parameters: ["include_image_language": "null"], expecting: Images.self, completion: completion)
    }
    
    private func fetchReviews(completion: @escaping (Result<Reviews, Error>) -> Void) {
        let endpoint = Endpoint.movieReviews(movieId: movie.id)
        NetworkService.shared.execute(endpoint: endpoint, expecting: Reviews.self, completion: completion)
    }
    
    private func fetchRecommendations(completion: @escaping (Result<Movies, Error>) -> Void) {
        let endpoint = Endpoint.movieRecommendations(movieId: movie.id)
        NetworkService.shared.execute(endpoint: endpoint, expecting: Movies.self, completion: completion)
    }
    
    func rateMovie(movieId: Int, value: Double, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let sessionID = SessionManager.shared.sessionId else {
            completion(.failure(NetworkService.NetworkServiceError.invalidSession))
            return
        }

        let endpoint = Endpoint.movieAddRating(movieId: movieId, rating: value)
        
        NetworkService.shared.execute(endpoint: endpoint, parameters: ["session_id": sessionID], expecting: APIResponse<Bool>.self) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func removeRating(movieId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let sessionID = SessionManager.shared.sessionId else {
            completion(.failure(NetworkService.NetworkServiceError.invalidSession))
            return
        }

        let endpoint = Endpoint.movieDeleteRating(movieId: movieId)
        
        NetworkService.shared.execute(endpoint: endpoint, parameters: ["session_id": sessionID], expecting: APIResponse<Bool>.self) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func toggleWatchlist(mediaType: String, mediaId: Int, watchlist: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let sessionID = SessionManager.shared.sessionId else {
            completion(.failure(NetworkService.NetworkServiceError.invalidSession))
            return
        }

        let endpoint = Endpoint.accountAddToWatchlist(mediaType: mediaType, mediaId: mediaId, watchlist: watchlist)
        
        NetworkService.shared.execute(endpoint: endpoint, parameters: ["session_id": sessionID], expecting: APIResponse<Bool>.self) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }

        let sectionType = sections[section]

        switch sectionType {
        case .backdrop:
            return 1
        case .facts(let factViewModels):
            return factViewModels.count
        case .overview(let overviewViewModels):
            return overviewViewModels.count
        case .images(let imageViewModels):
            return imageViewModels.count
        case .genres(let genreViewModels):
            return genreViewModels.count
        case .cast(let castViewModels):
            return castViewModels.count
        case .reviews(let reviewViewModels):
            return reviewViewModels.count
        case .recommendations(let recommendationViewModels):
            return recommendationViewModels.count
        }
    }
    
    func recommendation(at index: Int) -> Movie? {
        return recommendations[index]
    }

}
