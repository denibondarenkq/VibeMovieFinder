import Foundation

public enum Endpoint {
    case requestToken
    case createSessionId(requestToken: String)
    case deleteSession(sessionId: String)
    case accountWatchlistMovies
    case accountRatedMovies
    case movieDetails(movieId: Int)
    case genreMovieList
    case movieAccountStates(movieId: Int)
    case moviePopular
    case movieCredits(movieId: Int)
    case movieImages(movieId: Int)
    case movieRecommendations(movieId: Int)
    case movieReviews(movieId: Int)
    case searchMovie
    case movieAddRating(movieId: Int, rating: Double)
    case movieDeleteRating(movieId: Int)
    case accountAddToWatchlist(mediaType: String, mediaId: Int, watchlist: Bool)
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
        case .requestToken:
            return "authentication/token/new"
        case .createSessionId:
            return "authentication/session/new"
        case .deleteSession:
            return "authentication/session"
        case .accountWatchlistMovies:
            return "account/account_id/watchlist/movies"
        case .accountRatedMovies:
            return "account/account_id/rated/movies"
        case .movieDetails(let movieId):
            return "movie/\(movieId)"
        case .genreMovieList:
            return "genre/movie/list"
        case .movieAccountStates(let movieId):
            return "movie/\(movieId)/account_states"
        case .moviePopular:
            return "movie/popular"
        case .movieCredits(let movieId):
            return "movie/\(movieId)/credits"
        case .movieImages(let movieId):
            return "movie/\(movieId)/images"
        case .movieRecommendations(let movieId):
            return "movie/\(movieId)/recommendations"
        case .movieReviews(let movieId):
            return "movie/\(movieId)/reviews"
        case .searchMovie:
            return "search/movie"
        case .movieAddRating(let movieId, _):
            return "movie/\(movieId)/rating"
        case .movieDeleteRating(let movieId):
            return "movie/\(movieId)/rating"
        case .accountAddToWatchlist:
            return "account/account_id/watchlist"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestToken, .accountWatchlistMovies, .accountRatedMovies, .movieAccountStates, .movieDetails, .genreMovieList, .moviePopular, .movieCredits, .movieImages, .movieRecommendations, .movieReviews, .searchMovie:
            return .GET
        case .createSessionId, .movieAddRating, .accountAddToWatchlist:
            return .POST
        case .deleteSession, .movieDeleteRating:
            return .DELETE
        }
    }
    
    var headers: [String: String]? {
        guard let bearerToken = APIKeyManager.shared.bearerToken else { return nil }
        return [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer \(bearerToken)"
        ]
    }
    
    var bodyParameters: [String: Any]? {
        switch self {
        case .createSessionId(let requestToken):
            return ["request_token": requestToken]
        case .deleteSession(let sessionId):
            return ["session_id": sessionId]
        case .movieAddRating(_, let rating):
            return ["value": rating]
        case .accountAddToWatchlist(let mediaType, let mediaId, let watchlist):
            return [
                "media_type": mediaType,
                "media_id": mediaId,
                "watchlist": watchlist
            ]
        default:
            return nil
        }
    }
    
    func makeRequest(parameters: [String: Any] = [:]) throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)!
        
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        
        guard let url = components.url else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 10
        
        if let bodyParameters = bodyParameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
        }
        
        return request
    }
}
