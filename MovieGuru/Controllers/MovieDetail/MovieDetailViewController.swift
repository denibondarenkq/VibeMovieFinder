//
//  MovieDetailViewController.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 04.08.2024.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    private let movieCollectionView: MovieDetailCollectionView
    private let viewModel: MovieDetailViewModel
    
    init(movie: MovieSummary) {
        self.viewModel = MovieDetailViewModel(movie: movie)
        self.movieCollectionView = MovieDetailCollectionView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func loadView() {
        super.loadView()
        configureView()
        setupConstraints()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    }
    
    private func configureView() {
        title = viewModel.title
        view.addSubview(movieCollectionView)
        view.backgroundColor = .systemBackground
    }
    
    @objc
    private func didTapShare() {
        // Share character info
    }

    private func setupConstraints() {
        movieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            movieCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupBindings() {
//        viewModel.delegate = self
//        movieTableView.delegate = self
    }
}
