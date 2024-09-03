import UIKit

protocol SectionLayoutStrategy {
    func createSectionLayout() -> NSCollectionLayoutSection
}

struct BackdropSectionLayoutStrategy: SectionLayoutStrategy {
    func createSectionLayout() -> NSCollectionLayoutSection {
        return LayoutFactory.createSectionLayout(
            itemWidth: .fractionalWidth(1.00),
            itemHeight: .fractionalHeight(1.00),
            groupWidth: .fractionalWidth(1.0),
            groupHeight: .absolute(180),
            scrollBehavior: nil,
            groupInsets: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
            sectionInsets: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: Spacing.large, trailing: 0)
        )
    }
}

struct DefaultSectionLayoutStrategy: SectionLayoutStrategy {
    let groupWidth: NSCollectionLayoutDimension
    let groupHeight: NSCollectionLayoutDimension

    func createSectionLayout() -> NSCollectionLayoutSection {
        return LayoutFactory.createSectionLayout(
            itemWidth: .fractionalWidth(1.0),
            itemHeight: .fractionalHeight(1.0),
            groupWidth: groupWidth,
            groupHeight: groupHeight,
            scrollBehavior: .continuousGroupLeadingBoundary,
            groupInsets: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: Spacing.medium),
            sectionInsets: NSDirectionalEdgeInsets(top: Spacing.medium, leading: Spacing.large, bottom: Spacing.large, trailing: Spacing.large)
        )
    }
}

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
