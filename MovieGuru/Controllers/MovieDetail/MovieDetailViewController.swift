//
//  MovieDetailViewController.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 04.08.2024.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    private let movieCollectionView = MovieDetailCollectionView()
    private let viewModel: MovieDetailViewModel
    
    init(movie: MovieSummary) {
        self.viewModel = MovieDetailViewModel(movie: movie)
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
        configureNavigationBar()
        viewModel.delegate = self
        viewModel.fetchContent()
    }
    
    private func configureView() {
        title = viewModel.title
        view.addSubview(movieCollectionView)
        view.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    }

    @objc
    private func didTapShare() {
        // Share movie info
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
        // Bindings setup if needed
    }
}

// MARK: - MovieDetailViewModelDelegate

extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func didFetchMovieDetails() {
        movieCollectionView.configure(with: viewModel)
    }
}
