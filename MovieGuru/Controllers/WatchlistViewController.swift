//
//  WatchlistViewController.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import UIKit

/// Controller to show and manage Watchlist
class WatchlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let primaryView = MovieView()
    private let viewModel = WatchlistTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
        title = "Watchlist"
        
        primaryView.tableView.delegate = self
        primaryView.tableView.dataSource = self
        
        addConstraints()
        viewModel.fetchMovies()
        primaryView.configure(with: viewModel)
    }
    
    private func addConstraints() {
        primaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    // MARK: - UITableViewDataSource
    
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
    
    // MARK: - UITableViewDelegate
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        // Handle cell selection
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieTableViewCell.cellHeight
    }

}
