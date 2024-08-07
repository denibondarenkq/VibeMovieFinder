//
//  MovieDetailViewModel.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 07.08.2024.
//

import UIKit

class MovieDetailCollectionView : UIView {
    public var collectionView: UICollectionView?
    private var viewModel: MovieDetailViewModel
    
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    init(frame: CGRect, viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubview(activityIndicator)
        addSubview(collectionView)
        addConstraints()
        activityIndicator.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func updateView() {
//        activityIndicator.stopAnimating()
//        collectionView.isHidden = false
//        collectionView.reloadData()
//        UIView.animate(withDuration: 0.3) {
//            self.collectionView.alpha = 1
//        }
//    }
    
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
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieBackdropCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieBackdropCollectionViewCell.cellIdentifer)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex]  {
        case .backdrop:
            return viewModel.createBackdropSectionLayout()
        case .overview:
            return viewModel.createBackdropSectionLayout()
        case .images:
            return viewModel.createBackdropSectionLayout()
        case .genres:
            return viewModel.createBackdropSectionLayout()
        case .cast:
            return viewModel.createBackdropSectionLayout()
        case .recommendations:
            return viewModel.createBackdropSectionLayout()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MovieDetailCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .backdrop:
            return 1
        case .overview:
            return 0
        case .images:
            return 0
        case .genres:
            return 0
        case .cast:
            return 0
        case .recommendations:
            return 0
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MovieDetailCollectionView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
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
