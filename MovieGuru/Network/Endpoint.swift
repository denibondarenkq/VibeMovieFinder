//
//  APICaller.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 05.07.2024.
//

import Foundation

public enum Endpoint {
    case accountAddToWatchList(accountId: Int, sessionId: String, movieId: Int)
    case accountWatchList(accountId: Int, page: Int, sortBy: String)
    case movieDetails(movieId: Int)
    case genresMovieList

    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
        case .accountAddToWatchList(let accountId, _, _):
            return "account/\(accountId)/watchlist"
        case .accountWatchList(let accountId, _, _):
            return "account/\(accountId)/watchlist/movies"
        case .movieDetails(let movieId):
            return "movie/\(movieId)"
        case .genresMovieList:
            return "genre/movie/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .accountAddToWatchList:
            return .POST
        case .accountWatchList, .movieDetails, .genresMovieList:
            return .GET
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .accountWatchList(_, let page, let sortBy):
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "sort_by", value: sortBy)
            ]
        case .genresMovieList:
            return [
                URLQueryItem(name: "language", value: "en")
            ]
        default:
            return nil
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
        case .accountAddToWatchList(_, _, let movieId):
            return ["media_id": movieId]
        default:
            return nil
        }
    }
    
    var url: URL {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems
        
        guard let url = components.url else {
            fatalError("Invalid URL")
        }
        
        return url
    }
    
    func makeRequest() throws -> URLRequest {
        let url = self.url
        
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
