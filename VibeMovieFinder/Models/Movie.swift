import Foundation

struct Movie: Codable {
    let adult: Bool?
    let backdropPath, posterPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let releaseDate, title: String
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int?
    let mediaType: String?
    let rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case mediaType = "media_type"
        case rating
    }
}

struct Movies: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieGemini: Codable {
    let title: String
    let releaseYear: Int
}
