//
//  MovieTableViewCell.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    static let cellHeight: CGFloat = 190
    
    static let cellIdentifier = "MovieTableViewCell"


    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.title
        label.numberOfLines = 2
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.regular
        label.textColor = .label
        return label
    }()
    
    private let genresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = Padding.small
        return stackView
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.light
        label.textColor = .label
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
        imageView.image = UIImage(systemName: "star.circle.fill")
        imageView.tintColor = .systemOrange
        return imageView
    }()
    
    private let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "calendar.circle.fill")
        imageView.tintColor = .label
        return imageView
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(genresStackView)
        contentView.addSubview(yearLabel)
        contentView.addSubview(movieImageView)
        contentView.addSubview(starImageView)
        contentView.addSubview(calendarImageView)
    }
    
    private func addConstraints() {
        let calendarStackView = UIStackView(arrangedSubviews: [calendarImageView, yearLabel])
        calendarStackView.translatesAutoresizingMaskIntoConstraints = false
        calendarStackView.spacing = Padding.small
        calendarStackView.alignment = .center

        let ratingStackView = UIStackView(arrangedSubviews: [starImageView, ratingLabel])
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.spacing = Padding.small
        ratingStackView.alignment = .center

        let informationStack = UIStackView(arrangedSubviews: [ratingStackView, calendarStackView])
        informationStack.translatesAutoresizingMaskIntoConstraints = false
        informationStack.axis = .horizontal
        informationStack.spacing = Padding.medium
        informationStack.alignment = .center

        let contentStackView = UIStackView(arrangedSubviews: [nameLabel, informationStack, genresStackView])
        contentStackView.axis = .vertical
        contentStackView.spacing = Padding.medium
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentStackView)
        
        contentStackView.alignment = .leading

        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.large),
            movieImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Padding.large),
            movieImageView.widthAnchor.constraint(equalToConstant: 100),
            movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 1.5),  // 2:3 aspect ratio

            contentStackView.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor),
            contentStackView.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: Padding.medium),
            contentStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Padding.large),

            nameLabel.leftAnchor.constraint(equalTo: contentStackView.leftAnchor),

            genresStackView.rightAnchor.constraint(lessThanOrEqualTo: contentStackView.rightAnchor),
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
        
        // Calculate available width in genresStackView
        let availableWidth = contentView.bounds.width - (Padding.large + 100 + Padding.medium + Padding.large) // Padding + Image + Padding + Padding
        var currentWidth: CGFloat = 0

        for genreName in viewModel.genreNames {
            let genreLabel = createGenreLabel(for: genreName)
            let genreWidth = genreLabel.intrinsicContentSize.width + Padding.small
            
            if currentWidth + genreWidth <= availableWidth {
                genresStackView.addArrangedSubview(genreLabel)
                currentWidth += genreWidth + Padding.small
            } else {
                break
            }
        }
        
        if let posterURL = viewModel.posterURL {
            loadImage(from: posterURL)
        }
    }
    
    private func createGenreLabel(for genreName: String) -> UILabel {
        let label = UILabel()
        label.text = genreName
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemBackground
        label.backgroundColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        
        let widthConstraint = label.widthAnchor.constraint(equalToConstant: label.intrinsicContentSize.width + Padding.medium)
        widthConstraint.isActive = true
        
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
