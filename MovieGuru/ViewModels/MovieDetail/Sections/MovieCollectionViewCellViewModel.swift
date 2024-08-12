//
//  RecommendationCollectionViewCellViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 11.08.2024.
//

import Foundation

final class MovieCollectionViewCellViewModel {
    public let title: String
    private let imageUrl: URL?
    
    init(title: String, posterPath: String?) {
        self.title = title
        if let posterPath = posterPath {
            self.imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        } else {
            self.imageUrl = nil
        }
    }
    
    func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageService.shared.downloadImage(from: url, completion: completion)
    }
}
