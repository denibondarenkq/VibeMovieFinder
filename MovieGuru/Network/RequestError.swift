//
//  RequestError.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 05.07.2024.
//

import Foundation

enum RequestError: Error {
    case wrongUrl(URLComponents)
    case unexpectedResponse(URLResponse)
    case failedResponse(HTTPURLResponse)
}
