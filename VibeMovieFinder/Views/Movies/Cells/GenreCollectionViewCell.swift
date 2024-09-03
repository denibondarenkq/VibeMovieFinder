import UIKit

final class GenreCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "GenreCollectionViewCellViewCell"

    private let genreLabel: UILabel = {
        return UIComponentFactory.createLabel(font: TextStyle.heading2, textColor: .systemBackground, textAlignment: .center)
    }()
    
    private let shadowView = UIComponentFactory.createShadowView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .label
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.addSubview(shadowView)
        shadowView.addSubview(genreLabel)
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.medium),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.medium),
            genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        genreLabel.text = nil
    }

    public func configure(with viewModel: GenreCollectionViewCellViewModel) {
        genreLabel.text = viewModel.name
    }
}
