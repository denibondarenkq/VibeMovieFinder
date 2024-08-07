//
//  MovieDetailViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 04.08.2024.
//

import UIKit

class MovieDetailViewModel {
    private let movie: MovieSummary
    
    enum SectionType {
        case backdrop(viewModel: MovieBackdropCollectionCellViewModel)
        case overview
        case images
        case genres
        case cast
        case recommendations
    }
    public var sections: [SectionType] = []
    
    init(movie: MovieSummary) {
        self.movie = movie
        setUpSections()
    }
    
    private func setUpSections() {
        sections = [
            .backdrop(viewModel: MovieBackdropCollectionCellViewModel(imageUrl: movie.backdropPath))
        ]
    }
    
    public var title: String {
        movie.title
    }
    
    public func createBackdropSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                     leading: 0,
                                                     bottom: 10,
                                                     trailing: 0)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize:  NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.3)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
