//
//  MovieCastCollectionViewCell.swift
//  MovieGuru
//
//  Created by Denys Bondarenko on 08.08.2024.
//

import UIKit

final class MovieCreditsCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "MovieCastCollectionViewCell"
    
    // UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray3
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 55
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = TextStyle.body
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = TextStyle.light
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(characterLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // ImageView Constraints
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 110),
            imageView.heightAnchor.constraint(equalToConstant: 110),
            
            // NameLabel Constraints
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Spacing.medium),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // CharacterLabel Constraints
            characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Spacing.small),
            characterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),

        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        characterLabel.text = nil
    }
    
    public func configure(with viewModel: MovieCreditsCollectionViewCellViewModel) {
        nameLabel.text = viewModel.name
        characterLabel.text = viewModel.character
        
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(systemName: "person")
                }
            }
        }
    }
}
