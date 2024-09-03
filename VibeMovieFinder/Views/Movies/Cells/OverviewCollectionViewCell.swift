import UIKit

final class OverviewCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "OverviewCollectionViewCell"
    
    private let shadowView = UIComponentFactory.createShadowView()
    
    private let containerView: UIView = {
        return UIComponentFactory.createContainerView(cornerRadius: 20, backgroundColor: .secondarySystemGroupedBackground)
    }()
    
    private let titleLabel: UILabel = {
        return UIComponentFactory.createLabel(font: TextStyle.heading2, textColor: .label, numberOfLines: 1)
    }()

    private let descriptionLabel: UILabel = {
        return UIComponentFactory.createLabel(font: TextStyle.body, textColor: .label, numberOfLines: 0, textAlignment: .left)
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(shadowView)
        shadowView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
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
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Spacing.medium),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Spacing.medium),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Spacing.medium),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.small),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Spacing.medium),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Spacing.medium),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -Spacing.medium)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    public func configure(with viewModel: OverviewCollectionViewCellViewModel) {
        titleLabel.text = viewModel.titleLabel
        descriptionLabel.text = viewModel.descriptionText
    }
}
