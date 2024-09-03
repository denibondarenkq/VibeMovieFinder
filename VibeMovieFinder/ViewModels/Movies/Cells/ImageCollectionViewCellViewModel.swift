import Foundation

final class ImageCollectionViewCellViewModel {
    public let imageUrl: URL?
    public let aspectRatio: Double
    
    init(imagePath: String?, aspectRatio: Double) {
        if let imagePath = imagePath {
            self.imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)")
        } else {
            self.imageUrl = nil
        }
        self.aspectRatio = aspectRatio
    }
    
    func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageService.shared.downloadImage(from: url, completion: completion)
    }
}
