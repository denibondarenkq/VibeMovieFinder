import UIKit

class LayoutFactory {
    static func createSectionLayout(
        itemWidth: NSCollectionLayoutDimension,
        itemHeight: NSCollectionLayoutDimension,
        groupWidth: NSCollectionLayoutDimension,
        groupHeight: NSCollectionLayoutDimension,
        scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior?,
        groupInsets: NSDirectionalEdgeInsets,
        sectionInsets: NSDirectionalEdgeInsets
    ) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: itemWidth,
                heightDimension: itemHeight
            )
        )
        
        let group: NSCollectionLayoutGroup = itemWidth == .fractionalWidth(1.0) ?
        NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: groupWidth,
                heightDimension: groupHeight
            ),
            subitems: [item]
        ) :
        NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: groupWidth,
                heightDimension: groupHeight
            ),
            subitems: [item]
        )
        
        group.contentInsets = groupInsets
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = sectionInsets
        
        if let scrollBehavior = scrollBehavior {
            section.orthogonalScrollingBehavior = scrollBehavior
        }
        
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    
    private static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}
