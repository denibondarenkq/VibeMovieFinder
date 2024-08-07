//
//  MovieDetailPhotoCollectionViewCellViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 07.08.2024.
//

import Foundation

class MovieBackdropCollectionCellViewModel {
    private let imageUrl: URL?
    
    init(imageUrl: String) {
        self.imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrl)")
    }
    
    public func fetchBackdropImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageService.shared.downloadImage(from: url, completion: completion)
    }
}
