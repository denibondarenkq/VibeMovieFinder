import UIKit

class CenteredVibeButtonFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var rowCollections: [[UICollectionViewLayoutAttributes]] = []
        var currentRowMaxY: CGFloat = -1.0
        
        for layoutAttribute in attributes {
            if layoutAttribute.frame.origin.y > currentRowMaxY {
                rowCollections.append([layoutAttribute])
                currentRowMaxY = layoutAttribute.frame.maxY
            } else {
                rowCollections[rowCollections.count - 1].append(layoutAttribute)
            }
        }
        
        for rowAttributes in rowCollections {
            let totalWidth = rowAttributes.reduce(0) { $0 + $1.frame.width } +
            CGFloat(rowAttributes.count - 1) * Spacing.medium
            let alignmentOffset = (collectionView!.bounds.width - totalWidth) / 2
            
            var leftMargin = alignmentOffset
            for layoutAttribute in rowAttributes {
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + Spacing.medium
            }
        }
        
        return attributes
    }
}
