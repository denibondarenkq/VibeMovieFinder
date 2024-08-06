//
//  APICaller.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 05.07.2024.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
//    private let cacheManager = APICacheManager()

    private init() {}

    enum NetworkServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
        case unexpectedResponse(URLResponse?)
        case apiError(String)
        case failedResponse(HTTPURLResponse?)
    }

    func execute<T: Decodable>(endpoint: Endpoint, parameters: [String: Any] = [:], expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
//        if let cachedData = cacheManager.cachedResponse(for: endpoint.url) {
//            do {
//                let result = try JSONDecoder().decode(type.self, from: cachedData)
//                completion(.success(result))
//            } catch {
//                completion(.failure(error))
//            }
//            return
//        }

        guard let urlRequest = try? endpoint.makeRequest(parameters: parameters) else {
            completion(.failure(NetworkServiceError.failedToCreateRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NetworkServiceError.failedToGetData))
                return
            }

            do {
                let result = try JSONDecoder().decode(type.self, from: data)
//                self?.cacheManager.setCache(for: endpoint.url, data: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
