//
//  WatchlistView.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import UIKit

protocol MovieTableViewDelegate: AnyObject {
    func movieTableView(_ movieTableView: MovieTableView, didSelect movie: MovieSummary)
}

class MovieTableView: UIView {
    weak var delegate: MovieTableViewDelegate?
    private var viewModel: BaseMoviesViewModel? {
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
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        return refreshControl
    }()
    
    public let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.alpha = 0
        table.estimatedRowHeight = MovieTableViewCell.cellHeight
        table.isHidden = true
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellIdentifier)
        return table
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupView() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
        
    public func configure(with viewModel: BaseMoviesViewModel) {
        self.viewModel = viewModel
    }
        
    private func updateView() {
        activityIndicator.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
    }
}

// MARK: - UITableViewDataSource

extension MovieTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.movieCellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellIdentifier, for: indexPath) as? MovieTableViewCell else {
            fatalError("Unable to dequeue MovieTableViewCell")
        }
        guard let cellViewModels = viewModel?.movieCellViewModels else {
            fatalError("IndexPath out of range for cellViewModels")
        }
        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MovieTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = viewModel?.movie(at: indexPath.row) else { return }
        delegate?.movieTableView(self, didSelect: movie)
    }
}

// MARK: - UIScrollViewDelegate

extension MovieTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        
        if offsetY > contentHeight - height - 100 {
            if viewModel?.hasMorePages == true, tableView.tableFooterView == nil {
                showLoadingFooter()
                viewModel?.fetchNextPage()
            }
        }
    }
    
    private func showLoadingFooter() {
        let footer = LoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
        tableView.tableFooterView = footer
    }
}
