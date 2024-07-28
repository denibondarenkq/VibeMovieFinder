//
//  WatchlistViewController.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import UIKit

class WatchlistViewController: UIViewController {
    private let movieTableView = MovieTableView()
    private let viewModel = WatchlistViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupConstraints()
        setupBindings()
        fetchInitialData()
        setupSortButton()
    }

    private func configureView() {
        title = "Watchlist"
        view.addSubview(movieTableView)
        view.backgroundColor = .systemGroupedBackground
    }

    private func setupSortButton() {
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(promptSortOrder))
        navigationItem.rightBarButtonItem = sortButton
    }

    @objc private func promptSortOrder() {
        let alert = UIAlertController(title: "Sort By", message: "Date Added", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ascending", style: .default, handler: { _ in
            self.viewModel.updateSortOrder(to: "created_at.asc")
        }))
        alert.addAction(UIAlertAction(title: "Descending", style: .default, handler: { _ in
            self.viewModel.updateSortOrder(to: "created_at.desc")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func setupConstraints() {
        movieTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.delegate = self
        movieTableView.configure(with: viewModel)
    }

    private func fetchInitialData() {
        viewModel.fetchMoviesAndGenres(page: 1)
    }
}

// MARK: - MovieTableViewDelegate

extension WatchlistViewController: MovieTableViewDelegate {
    func movieTableView(_ movieTableView: MovieTableView, didSelect movie: MovieSummary) {
        print(movie)
    }
    
    func movieView(_ movieView: MovieTableView, didSelect movie: MovieSummary) {
        // Navigation logic for selected movie
    }
}

// MARK: - BaseMoviesViewModelDelegate

extension WatchlistViewController: BaseMoviesViewModelDelegate {
    func didFetchMovies() {
        DispatchQueue.main.async {
            self.movieTableView.tableView.reloadData()
            self.movieTableView.tableView.tableFooterView = nil
        }
    }
}
