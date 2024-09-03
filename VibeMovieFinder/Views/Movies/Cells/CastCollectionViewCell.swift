import UIKit

final class CastCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "CastCollectionViewCell"

    private let imageView: UIImageView = UIComponentFactory.createImageView(contentMode: .scaleAspectFill, cornerRadius: 55)
    private let shadowView: UIView = UIComponentFactory.createShadowView()
    private let nameLabel: UILabel = UIComponentFactory.createLabel(font: TextStyle.heading2, textColor: .label, numberOfLines: 2, textAlignment: .center)
    private let characterLabel: UILabel = UIComponentFactory.createLabel(font: TextStyle.light, textColor: .label, numberOfLines: 2, textAlignment: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(shadowView)
        shadowView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(characterLabel)
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 110),
            imageView.heightAnchor.constraint(equalToConstant: 110),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Spacing.medium),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Spacing.small),
            characterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        characterLabel.text = nil
    }

    public func configure(with viewModel: CastCollectionViewCellViewModel) {
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
