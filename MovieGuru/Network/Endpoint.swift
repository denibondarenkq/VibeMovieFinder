//
//  APICaller.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 05.07.2024.
//

import Foundation

public enum Endpoint {
    case accountAddToWatchList(accountId: Int)
    case accountWatchList(accountId: Int)
    case movieDetails(movieId: Int)
    case genresMovieList
    case popularMovies
    case movieCredits(movieId: Int)

    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }

    var path: String {
        switch self {
        case .accountAddToWatchList(let accountId):
            return "account/\(accountId)/watchlist"
        case .accountWatchList(let accountId):
            return "account/\(accountId)/watchlist/movies"
        case .movieDetails(let movieId):
            return "movie/\(movieId)"
        case .genresMovieList:
            return "genre/movie/list"
        case .popularMovies:
            return "movie/popular"
        case .movieCredits(let movieId):
            return "movie/\(movieId)/credits"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .accountAddToWatchList:
            return .POST
        case .accountWatchList, .movieDetails, .genresMovieList, .popularMovies, .movieCredits:
            return .GET
        }
    }

    var headers: [String: String]? {
        guard let token = AuthManager.shared.token else { return nil }
        return [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }

    var bodyParameters: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }

    func makeRequest(parameters: [String: Any]) throws -> URLRequest {
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
