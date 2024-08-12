//
//  MovieDetailViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 07.08.2024.
//

import UIKit

protocol MovieDetailCollectionViewDelegate: AnyObject {
    func moviesTableView(_ movieTableView: MovieTableView, didSelect movie: MovieSummary)
}

final class MovieDetailSectionsView: UIView {
    private var collectionView: UICollectionView?
    private var viewModel: MovieDetailViewModel? {
        didSet {
            updateView()
        }
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(named: "BackgroundColor")
        let collectionView = createCollectionView()
        addSubview(collectionView)
        addSubview(activityIndicator)
        self.collectionView = collectionView
        addConstraints()
        activityIndicator.startAnimating()
    }
    
    private func addConstraints() {
        guard let collectionView = collectionView else { return }
        
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            self.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "BackgroundColor")
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieBackdropCollectionViewCell.self, forCellWithReuseIdentifier: MovieBackdropCollectionViewCell.cellIdentifer)
        collectionView.register(MovieCreditsCollectionViewCell.self, forCellWithReuseIdentifier: MovieCreditsCollectionViewCell.cellIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        return collectionView
    }
    
    private func updateView() {
        activityIndicator.stopAnimating()
        collectionView?.reloadData()
        collectionView?.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.collectionView?.alpha = 1
        }
    }
    
    public func configure(with viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
    }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.sections else {
            return createBackdropSectionLayout()
        }
        
        switch sections[sectionIndex] {
        case .backdrop:
            return createBackdropSectionLayout()
        case .cast:
            return createCreditsSectionLayout()
        case .recommendations:
            return createBackdropSectionLayout()
        }
    }
    
    private func createBackdropSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: Spacing.medium, trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.2)
            ),
            subitems: [item]
        )
        return NSCollectionLayoutSection(group: group)
    }
    
    public func createCreditsSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(120),
                heightDimension: .absolute(170)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: Spacing.medium)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(120),
                heightDimension: .absolute(170)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Spacing.large, bottom: 0, trailing: Spacing.large)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MovieDetailSectionsView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = viewModel?.sections[section] else {
            return 0
        }
        
        switch sectionType {
        case .backdrop:
            return 1
        case .cast(let viewModels):
            return viewModels.count
        case .recommendations:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = viewModel?.sections[indexPath.section] else {
            fatalError("No section available")
        }
        
        switch sectionType {
        case .backdrop(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieBackdropCollectionViewCell.cellIdentifer,
                for: indexPath
            ) as? MovieBackdropCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
            
        case .cast(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCreditsCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? MovieCreditsCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
            
        case .recommendations:
            fatalError("Cell not yet implemented")
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Invalid supplementary view kind")
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? SectionHeaderView else {
            fatalError("Could not dequeue SectionHeaderView")
        }
        
        guard let section = viewModel?.sections[indexPath.section] else {
            fatalError("No section available")
        }
        
        switch section {
        case .backdrop:
            header.configure(with: " ")
        case .cast:
            header.configure(with: "Top Billed Cast")
        case .recommendations:
            header.configure(with: "Recommendations")
        }
        
        return header
    }
}
