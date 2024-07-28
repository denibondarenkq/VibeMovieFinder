//
//  APICaller.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 05.07.2024.
//

import Foundation

final class APICaller {
    static let shared = APICaller()

    private init() {}

    func execute<T: Decodable>(endpoint: Endpoint, parameters: [String: Any] = [:], expecting: T.Type) async throws -> T {
        //        if let cachedData = CacheManager.shared.cachedResponse(for: endpoint) {
        //            do {
        //                return try JSONDecoder().decode(type.self, from: cachedData)
        //            } catch {
        //                throw APICallerError.decodingError(error)
        //            }
        //        }
        
        let urlRequest = try endpoint.makeRequest(parameters: parameters)
        let (data, _) = try await performRequest(urlRequest: urlRequest)
        let result = try JSONDecoder().decode(expecting, from: data)
        return result
    }
    
    
    private func performRequest(urlRequest: URLRequest, urlSession: URLSession = .shared) async throws -> (Data, URLResponse) {
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APICallerError.unexpectedResponse(response)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                throw APICallerError.apiError(apiError.message)
            }
            throw APICallerError.failedResponse(httpResponse)
        }
        return (data, response)
    }
}
