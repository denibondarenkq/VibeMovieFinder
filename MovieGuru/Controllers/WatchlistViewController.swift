//
//  WatchlistViewController.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import UIKit

/// Controller to show and manage Watchlist
class WatchlistViewController: UIViewController {

    // MARK: - Properties
    
    private let primaryView = MovieView()
    private let viewModel = MovieTableViewModel()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupBindings()
        fetchData()
    }

    // MARK: - Setup Methods
    
    private func setupView() {
        title = "Watchlist"
        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
        setupTableView()
    }

    private func setupTableView() {
        primaryView.tableView.delegate = self
        primaryView.tableView.dataSource = self
    }

    private func setupConstraints() {
        primaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupBindings() {
        viewModel.delegate = self
        primaryView.configure(with: viewModel)
    }
    
    private func fetchData() {
        viewModel.fetchGenres(endpoint: .generesMovieList) { [weak self] result in
            switch result {
            case .success:
                print("HEY")
                self?.viewModel.fetchMovies(endpoint: .accountWatchList(accountId: 21250428, page: 1, sortBy: "created_at.asc")) { result in
                    switch result {
                    case .success:
                        print("Movies loaded successfully")
                    case .failure(let error):
                        print("Error loading movies: \(error)")
                    }
                }
            case .failure(let error):
                print("Error fetching genres: \(error)")
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension WatchlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMovies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell.cellIdentifier", for: indexPath) as? MovieTableViewCell else {
            fatalError("Unable to dequeue MovieTableViewCell")
        }
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension WatchlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieTableViewCell.cellHeight
    }
}

// MARK: - MovieTableViewModelDelegate

extension WatchlistViewController: MovieTableViewModelDelegate {
    func didFetchMovies() {
        DispatchQueue.main.async {
            self.primaryView.tableView.reloadData()
        }
    }
}
