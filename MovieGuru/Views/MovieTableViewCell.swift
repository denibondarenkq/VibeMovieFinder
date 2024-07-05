//
//  MovieTableViewCell.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 24.06.2024.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    static let cellHeight: CGFloat = 170  // 150 for image + 20 for padding

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let yearDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
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
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(yearDurationLabel)
        contentView.addSubview(movieImageView)

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

            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            ratingLabel.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 10),
            ratingLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),

            yearDurationLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 10),
            yearDurationLabel.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: 10),
            yearDurationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            yearDurationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        ratingLabel.text = nil
        yearDurationLabel.text = nil
        movieImageView.image = nil
    }

    public func configure(with viewModel: MovieCellViewModel) {
        nameLabel.text = viewModel.name
        ratingLabel.text = "Rating: \(viewModel.rating)"
        yearDurationLabel.text = "\(viewModel.year) • \(viewModel.duration) min"
        movieImageView.image = viewModel.image
    }
}
