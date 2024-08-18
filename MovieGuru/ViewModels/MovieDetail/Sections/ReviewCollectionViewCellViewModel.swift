import Foundation

final class ReviewCollectionViewCellViewModel {
    public let author: String
    public let rating: String
    public let formattedDate: String
    public let content: String
    
    init(author: String, authorUsername: String, rating: Int?, createdAt: String, content: String) {
        self.author = author.isEmpty ? authorUsername : author
        self.rating = {
            if let rating = rating {
                return "Rating: \(rating)/10"
            } else {
                return "No Rating"
            }
        }()
        self.formattedDate = Self.formatDate(from: createdAt)
        self.content = content
    }
    
    private static func formatDate(from isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = formatter.date(from: isoDate) else {
            return isoDate
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        
        return displayFormatter.string(from: date)
    }
}
