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

    public func performRequest(
        endpoint: Endpoint,
        urlSession: URLSession = .shared
    ) async throws -> (Data, URLResponse) {
        let request = try endpoint.makeRequest()
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RequestError.unexpectedResponse(response)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw RequestError.failedResponse(httpResponse)
        }
        return (data, response)
    }
}
