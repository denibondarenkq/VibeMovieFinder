//
//  WatchlistView.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import UIKit

class MovieView: UIView {
    
    private var viewModel: MovieTableViewModel? {
        didSet {
            spinner.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
        }
    }
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    public let tableView: UITableView = {
            let table = UITableView(frame: .zero, style: .grouped)
            table.translatesAutoresizingMaskIntoConstraints = false
            table.alpha = 0
            table.isHidden = true
            table.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell.cellIdentifier")
            return table
        }()

    // MARK: - Init

    override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .systemBackground
            translatesAutoresizingMaskIntoConstraints = false
            addSubview(tableView)
            addSubview(spinner)
            spinner.startAnimating()
            addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addConstraints() {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: topAnchor),
                tableView.leftAnchor.constraint(equalTo: leftAnchor),
                tableView.rightAnchor.constraint(equalTo: rightAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
    }
        
    public func configure(with viewModel: MovieTableViewModel) {
        self.viewModel = viewModel
    }
}
