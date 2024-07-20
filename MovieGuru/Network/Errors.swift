//
//  RequestError.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 05.07.2024.
//

import Foundation

enum APICallerError: Error {
    case failedToGetData
    case unexpectedResponse(URLResponse)
    case failedResponse(HTTPURLResponse)
    case decodingError(Error)
    case wrongUrl(URLComponents)
    case apiError(String)
}

struct APIError: Codable {
    let statusCode: Int
    let message: String
}
