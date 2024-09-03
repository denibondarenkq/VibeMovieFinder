import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "MovieCollectionViewCell"
    
    private let imageView: UIImageView = {
        return UIComponentFactory.createImageView(contentMode: .scaleAspectFill, cornerRadius: 20)
    }()
    
    private let titleLabel: UILabel = {
        return UIComponentFactory.createLabel(font: TextStyle.heading2, textColor: .label, numberOfLines: 2, textAlignment: .center)
    }()
    
    private let shadowView = UIComponentFactory.createShadowView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(shadowView)
        shadowView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 130),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Spacing.medium),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    public func configure(with viewModel: MovieCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(systemName: "photo")
                }
            }
        }
    }
}
