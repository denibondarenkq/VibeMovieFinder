//
//  WatchlistViewController.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import UIKit

class WatchlistViewController: UIViewController {
    private let primaryView = MovieTableView()
    private let viewModel = WatchlistViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupBindings()
        fetchData()
        setupSortOrderButton()
    }

    private func setupView() {
        title = "Watchlist"
        view.addSubview(primaryView)
        view.backgroundColor = .systemGroupedBackground
    }

    private func setupSortOrderButton() {
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(changeSortOrder))
        navigationItem.rightBarButtonItem = sortButton
    }

    @objc private func changeSortOrder() {
        let alert = UIAlertController(title: "Sort By", message: "Date Added", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ascending", style: .default, handler: { _ in
            self.viewModel.updateSortOrder("created_at.asc")
        }))
        alert.addAction(UIAlertAction(title: "Descending", style: .default, handler: { _ in
            self.viewModel.updateSortOrder("created_at.desc")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func setupConstraints() {
        primaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.delegate = self
//        primaryView.delegate = self
        primaryView.configure(with: viewModel)

    }

    private func fetchData() {
        viewModel.fetchGenresAndMovies(page: 1)
    }

}

extension WatchlistViewController: MovieTableViewDelegate {
    func movieView(_ movieView: MovieTableView, didSelect movie: MovieSummary) {
        // let vc = WatchlistViewController(movie: MovieSummary)
        // vc.navigationItem.largeTitleDisplayMode = .never
        // navigationController?.pushViewController(vc, animated: true)
    }
}

extension WatchlistViewController: BaseMoviesViewModelDelegate {
    func didFetchMovies() {
        DispatchQueue.main.async {
            self.primaryView.tableView.reloadData()
            self.primaryView.tableView.tableFooterView = nil
        }
    }
}
