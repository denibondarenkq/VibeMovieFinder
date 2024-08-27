import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
}

struct Genres: Codable {
    let genres: [Genre]
}
