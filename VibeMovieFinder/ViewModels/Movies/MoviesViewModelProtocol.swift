import Foundation

protocol MoviesViewModelProtocol: AnyObject {
    var delegate: MoviesTableViewModelDelegate? { get set }
    var movieCellViewModels: [MovieTableViewCellViewModel] { get }
    
    func movie(at index: Int) -> Movie?
}

protocol PaginatedMoviesViewModelProtocol: MoviesViewModelProtocol {
    var hasMorePages: Bool { get }
    
    func configure(endpoint: Endpoint, initialParameters: [String: Any])
    func fetchMoviesAndGenres(page: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchNextPage()
    func updateRequestParameters(_ newParameters: [String: Any])
}

protocol MoviesTableViewModelDelegate: AnyObject {
    func didFetchMovies()
    func didFailToFetchMovies(with error: Error)
}
