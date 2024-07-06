//
//  MovieTableViewCell.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    static let cellHeight: CGFloat = 170

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GillSans-SemiBold", size: 24.0)
        label.numberOfLines = 2
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let genresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        return label
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .orange
        return imageView
    }()
    
    private let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .black
        return imageView
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(genresStackView)
        contentView.addSubview(yearLabel)
        contentView.addSubview(movieImageView)
        contentView.addSubview(starImageView)
        contentView.addSubview(calendarImageView)

        addConstraints()
        accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            movieImageView.widthAnchor.constraint(equalToConstant: 100),
            movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 1.5),  // 2:3 aspect ratio

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),

            starImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            starImageView.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 10),
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20),

            ratingLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            ratingLabel.leftAnchor.constraint(equalTo: starImageView.rightAnchor, constant: 5),

            genresStackView.topAnchor.constraint(equalTo: starImageView.bottomAnchor, constant: 10),
            genresStackView.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 10),
            genresStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),

            calendarImageView.topAnchor.constraint(equalTo: genresStackView.bottomAnchor, constant: 10),
            calendarImageView.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 10),
            calendarImageView.widthAnchor.constraint(equalToConstant: 20),
            calendarImageView.heightAnchor.constraint(equalToConstant: 20),

            yearLabel.centerYAnchor.constraint(equalTo: calendarImageView.centerYAnchor),
            yearLabel.leftAnchor.constraint(equalTo: calendarImageView.rightAnchor, constant: 5),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        ratingLabel.text = nil
        genresStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        yearLabel.text = nil
        movieImageView.image = nil
    }

    public func configure(with viewModel: MovieCellViewModel) {
        nameLabel.text = viewModel.name
        ratingLabel.text = "\(viewModel.rating)/10 TMDB"
        yearLabel.text = viewModel.year
        
        for genreID in viewModel.genreIDs {
            let genreLabel = createGenreLabel(for: genreID)
            genresStackView.addArrangedSubview(genreLabel)
        }
        
        if let posterURL = viewModel.posterURL {
            loadImage(from: posterURL)
        }
    }
    
    private func createGenreLabel(for genreID: Int) -> UILabel {
        let label = UILabel()
        label.text = String(genreID)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.backgroundColor = .black
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return label
    }

    private func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.movieImageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
