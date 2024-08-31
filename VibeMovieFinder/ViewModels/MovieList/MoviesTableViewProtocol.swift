import Foundation

protocol MoviesListViewModelProtocol: AnyObject {
    var delegate: MoviesTableViewModelDelegate? { get set }
    var movieCellViewModels: [MovieTableViewCellViewModel] { get }
    var hasMorePages: Bool { get }
    
    func fetchMoviesAndGenres(page: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchNextPage()
    func movie(at index: Int) -> Movie?
}

protocol MoviesTableViewModelDelegate: AnyObject {
    func didFetchMovies()
    func didFailToFetchMovies(with error: Error)
}
