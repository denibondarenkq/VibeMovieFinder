import Foundation

final class FactCollectionViewCellViewModel {
    public let title: String
    public let value: String
    public let emoji: String
    
    init(title: String, value: String, emoji: String) {
        self.title = title
        self.value = value
        self.emoji = emoji
    }
}
