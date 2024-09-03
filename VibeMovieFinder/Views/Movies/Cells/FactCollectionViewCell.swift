import UIKit

final class FactCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "FactsCollectionViewCell"
    
    private let emojiLabel: UILabel = {
        return UIComponentFactory.createLabel(font: UIFont.systemFont(ofSize: 24), textColor: .label, textAlignment: .center)
    }()
    
    private let valueLabel: UILabel = {
        return UIComponentFactory.createLabel(font: TextStyle.heading2, textColor: .label, textAlignment: .center)
    }()
    
    private let titleLabel: UILabel = {
        return UIComponentFactory.createLightLabel()
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: Spacing.medium),
            valueLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: Spacing.small),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        emojiLabel.text = nil
        titleLabel.text = nil
        valueLabel.text = nil
    }
    
    public func configure(with viewModel: FactCollectionViewCellViewModel) {
        emojiLabel.text = viewModel.emoji
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
}
