import Foundation

protocol MovieDetailSectionsViewViewModelDelegate: AnyObject {
    func didFetchMovieDetails()
}

class MovieDetailSectionsViewViewModel {
    private let movie: Movie
    private var genres: [Genre] = []
    private var credits: [Cast] = []
    private var images: [Backdrop] = []
    private var reviews: [Review] = []
    private var recommendations: [Movie] = []
    
    weak var delegate: MovieDetailSectionsViewViewModelDelegate?
    
    enum SectionType {
        case backdrop(viewModel: BackdropCollectionViewCellViewModel)
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
    
    public func fetchContent() {
        let dispatchGroup = DispatchGroup()
        var fetchError: Error?
        
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
                /// TO:DO: Handle error
                return
            }
            self.setUpSections()
            self.delegate?.didFetchMovieDetails()
        }
    }
    
    private func setUpSections() {
        sections = [
            .backdrop(viewModel: BackdropCollectionViewCellViewModel(imageUrl: movie.backdropPath)),
            .genres(viewModels: genres.compactMap { genre in
                GenreCollectionViewCellViewModel(name: genre.name)
            }),
            .cast(viewModels: credits.compactMap { cast in
                CastCollectionViewCellViewModel(
                    name: cast.name,
                    character: cast.character,
                    job: cast.job,
                    imageUrl: cast.profilePath
                )
            }),
            .images(viewModels: images.compactMap { image in
                ImageCollectionViewCellViewModel(
                    imagePath: image.filePath,
                    aspectRatio: image.aspectRatio
                )
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
    
    private func fetchGenres(completion: @escaping (Result<Genres, Error>) -> Void) {
        NetworkService.shared.execute(endpoint: .genreMovieList, expecting: Genres.self, completion: completion)
    }
    
    private func fetchCredits(completion: @escaping (Result<Credits, Error>) -> Void) {
        let endpoint = Endpoint.movieCredits(movieId: movie.id)
        NetworkService.shared.execute(endpoint: endpoint, expecting: Credits.self, completion: completion)
    }
    
    private func fetchImages(completion: @escaping (Result<Images, Error>) -> Void) {
        let endpoint = Endpoint.movieImages(movieId: movie.id)
        NetworkService.shared.execute(endpoint: endpoint, parameters: ["name": "language", "value": "null"], expecting: Images.self, completion: completion)
    }
    
    private func fetchReviews(completion: @escaping (Result<Reviews, Error>) -> Void) {
        let endpoint = Endpoint.movieReviews(movieId: movie.id)
        NetworkService.shared.execute(endpoint: endpoint, expecting: Reviews.self, completion: completion)
    }
    
    private func fetchRecommendations(completion: @escaping (Result<Movies, Error>) -> Void) {
        let endpoint = Endpoint.movieRecommendations(movieId: movie.id)
        NetworkService.shared.execute(endpoint: endpoint, expecting: Movies.self, completion: completion)
    }
}
