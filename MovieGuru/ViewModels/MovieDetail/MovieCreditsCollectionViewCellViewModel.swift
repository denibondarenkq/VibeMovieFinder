//
//  MovieCastCollectionViewCellViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 08.08.2024.
//

import Foundation

final class MovieCreditsCollectionViewCellViewModel {
    public let name: String
    public let character: String
    private let imageUrl: URL?
    
    init(name: String, character: String?, job: String?, imageUrl: String?) {
        self.name = name
        self.character = character ?? job ?? ""
        if let imageUrl = imageUrl {
            self.imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrl)")
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
