import Foundation

public enum Endpoint {
    case requestToken
    case createSessionId(requestToken: String)
    case accountAddToWatchList
    case accountWatchlistMovies(sessionID: String)
    case movieDetails(movieId: Int)
    case genreMovieList
    case moviePopular
    case movieCredits(movieId: Int)
    case movieImages(movieId: Int)
    case movieRecommendations(movieId: Int)
    case movieReviews(movieId: Int)
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
        case .requestToken:
            return "authentication/token/new"
        case .createSessionId:
            return "authentication/session/new"
        case .accountAddToWatchList:
            return "account/account_id/watchlist"
        case .accountWatchlistMovies:
            return "account/account_id/watchlist/movies"
        case .movieDetails(let movieId):
            return "movie/\(movieId)"
        case .genreMovieList:
            return "genre/movie/list"
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
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .requestToken, .accountWatchlistMovies, .movieDetails, .genreMovieList, .moviePopular, .movieCredits, .movieImages, .movieRecommendations, .movieReviews:
            return .GET
        case .createSessionId, .accountAddToWatchList:
            return .POST
        }
    }
    
    var headers: [String: String]? {
        guard let bearerToken = AuthManager.shared.bearerToken else { return nil }
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
        default:
            return nil
        }
    }
    
    func makeRequest(parameters: [String: Any] = [:]) throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)!
        
        // Добавляем sessionID в queryItems, если это accountWatchlistMovies
        var allParameters = parameters
        if case let .accountWatchlistMovies(sessionID) = self {
            allParameters["session_id"] = sessionID
        }
        
        components.queryItems = allParameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        
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
