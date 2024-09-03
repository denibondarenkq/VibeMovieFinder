import UIKit

final class ReviewCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "ReviewCollectionViewCell"
    
    private let shadowView: UIView = UIComponentFactory.createShadowView()
    private let containerView = UIComponentFactory.createContainerView()
    
    private let authorLabel: UILabel = UIComponentFactory.createLabel(font: TextStyle.heading2, textColor: .label)
    
    private let ratingLabel: UILabel = UIComponentFactory.createLabel(font: TextStyle.light, textColor: .label)
    
    private let dateLabel: UILabel = UIComponentFactory.createLabel(font: TextStyle.light, textColor: .label)
    
    private let contentLabel: UILabel = UIComponentFactory.createLabel(font: TextStyle.body, textColor: .label, numberOfLines: 7)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(shadowView)
        shadowView.addSubview(containerView)
        containerView.addSubview(authorLabel)
        containerView.addSubview(ratingLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(contentLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            authorLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Spacing.medium),
            authorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Spacing.medium),
            authorLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -Spacing.medium),
            
            ratingLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: Spacing.small),
            ratingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Spacing.medium),
            ratingLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -Spacing.medium),
            
            dateLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: Spacing.small),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Spacing.medium),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -Spacing.medium),
            
            contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Spacing.small),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Spacing.medium),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Spacing.medium),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -Spacing.medium)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        ratingLabel.text = nil
        dateLabel.text = nil
        contentLabel.text = nil
    }
    
    public func configure(with viewModel: ReviewCollectionViewCellViewModel) {
        authorLabel.text = viewModel.author
        ratingLabel.text = "⭐️ \(viewModel.rating)"
        dateLabel.text = viewModel.formattedDate
        contentLabel.text = viewModel.content
    }
}
