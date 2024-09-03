import Foundation

final class MovieTableViewCellViewModel {
    
    public let title: String
    public let rating: String
    public let releaseYear: String
    public let genreNames: [String]
    public let verdict: Int?
    private let posterPath: String?
    
    init(title: String, voteAverage: Double, releaseDate: String, genreIDs: [Int], genres: [Genre], posterPath: String?, verdict: Int?) {
        self.title = title
        self.rating = String(format: "%.1f", voteAverage)
        self.releaseYear = String(releaseDate.prefix(4))
        self.genreNames = genreIDs.compactMap { id in
            genres.first(where: { $0.id == id })?.name
        }
        self.posterPath = posterPath
        self.verdict = verdict
    }
    
    public var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    func fetchPosterImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = posterURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageService.shared.downloadImage(from: url, completion: completion)
    }
}
