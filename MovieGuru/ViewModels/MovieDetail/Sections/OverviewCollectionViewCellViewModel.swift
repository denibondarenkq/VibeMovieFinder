import Foundation

final class OverviewCollectionViewCellViewModel {
    public let titleLabel: String
    public let descriptionText: String
    
    init(titleLabel: String, descriptionText: String) {
        self.titleLabel = titleLabel
        self.descriptionText = descriptionText
    }
}
