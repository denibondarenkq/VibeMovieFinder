//
//  MovieDetailViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 07.08.2024.
//

import UIKit

class MovieDetailCollectionView : UIView {
    public var collectionView: UICollectionView?
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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        addSubview(collectionView)
        addSubview(activityIndicator)
        self.collectionView = collectionView
        addConstraints()
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        
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
            return self.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieBackdropCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieBackdropCollectionViewCell.cellIdentifer)
        collectionView.register(MovieCreditsCollectionViewCell.self, forCellWithReuseIdentifier: MovieCreditsCollectionViewCell.cellIdentifier)
        return collectionView
    }
    
    
}

// MARK: - UICollectionViewDelegate

extension MovieDetailCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.sections else {
            return 0
        }
        let sectionType = sections[section]
        let itemCount: Int

        switch sectionType {
        case .backdrop:
            itemCount = 1
        case .overview:
            itemCount = 0
        case .cast(let viewModels):
            itemCount = viewModels.count
        case .recommendations:
            itemCount = 0
        }
        
        print("Section \(section), Item Count: \(itemCount)")
        return itemCount
    }

}

// MARK: - UICollectionViewDataSource
extension MovieDetailCollectionView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = viewModel?.sections else {
            fatalError("No viewModel")
        }
        let sectionType = sections[indexPath.section]

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
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCreditsCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? MovieCreditsCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieBackdropCollectionViewCell.cellIdentifer,
                for: indexPath
            ) as? MovieBackdropCollectionViewCell else {
                fatalError()
            }
//            cell.configure(with: viewModel)
            return cell
        }
    }
    
    
}

extension MovieDetailCollectionView {
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        print("Creating section for index \(sectionIndex)")

        guard let sections = viewModel?.sections else {
            return createBackdropSectionLayout()
        }
        
        switch sections[sectionIndex]  {
        case .backdrop:
            return createBackdropSectionLayout()
        case .overview:
            return createBackdropSectionLayout()
//        case .images:
//            return createBackdropSectionLayout()
//        case .genres:
//            return createBackdropSectionLayout()
        case .cast:
            return createCreditsSectionLayout()
        case .recommendations:
            return createBackdropSectionLayout()
        }
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
    
    public func createCreditsSectionLayout() -> NSCollectionLayoutSection {
        // 1. Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute((120)),
                heightDimension: .absolute(185)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        // 2. Group
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(120),
                heightDimension: .absolute(185)
            ),
            subitems: [item]
        )
        
        // 3. Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        // 4. Section Header
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

    
    public func configure(with viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
    }
    
    private func updateView() {
        activityIndicator.stopAnimating()
        self.collectionView?.reloadData()
        self.collectionView?.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.collectionView?.alpha = 1
        }
    }
}
