//
//  APICaller.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 05.07.2024.
//

import Foundation

public enum Endpoint {
    case accountaddToWatchList(accountId: Int, sessionId: String, movieId: Int)
    case accountWatchList(accountId: Int, page: Int, sortBy: String)
    case moviesDetails(movieId: Int)
    case generesMovieList
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
        case .accountaddToWatchList(let accountId, _, _):
            return "account/\(accountId)/watchlist"
        case .accountWatchList(let accountId, _, _):
            return "account/\(accountId)/watchlist/movies"
        case .moviesDetails(let movieId):
            return "movie/\(movieId)"
        case .generesMovieList:
            return "genre/movie/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .accountaddToWatchList:
            return .POST
        case .accountWatchList, .moviesDetails, .generesMovieList:
            return .GET
            //TODO: .GET, .PUT, .DELETE
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .accountWatchList(_, let page, let sortBy): //TODO: sort by
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "sort_by", value: "\(sortBy)")
            ]
            //TODO: other cases
        case .generesMovieList:
            return [
                URLQueryItem(name: "language", value: "en")
            ]
        default:
            return nil
        }
    }
    
    var headers: [String: String]? {
        guard let token = AuthManager.shared.token else { return nil }
        
        let headers = [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        return headers
    }
    
//    var bodyParameters: [String: Any]? {
//            switch self {
//            case .addToWatchList(_, _, let movieId):
//                return ["media_id": movieId]
//            default:
//                return nil
//            }
//        }
    
    func makeRequest() throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems
       
        guard let url = components.url else {
            throw RequestError.wrongUrl(components)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 10

//            if let bodyParameters = bodyParameters {
//                request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
//            }

        return request
    }
}
