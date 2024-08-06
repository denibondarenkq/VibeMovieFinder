//
//  ImageService.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 06.08.2024.
//

import Foundation

final class ImageService {
    static let shared = ImageService()
    private let imageDataCache = NSCache<NSString, NSData>()

    private init() {}

    enum ImageServiceError: Error {
        case failedToGetData
        case invalidURL
    }

    func downloadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? ImageServiceError.failedToGetData))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
