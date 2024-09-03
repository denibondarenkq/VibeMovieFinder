import UIKit

final class UIComponentFactory {

    static func createLabel(font: UIFont, textColor: UIColor, numberOfLines: Int = 1, textAlignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.textAlignment = textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TextStyle.heading1
        label.numberOfLines = 2
        return label
    }
    
    static func createRegularLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TextStyle.body
        label.textColor = .label
        return label
    }
    
    static func createLightLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TextStyle.light
        label.textColor = .label
        return label
    }
    
    static func createGenreLabel(for genreName: String) -> UILabel {
        let label = UILabel()
        label.text = genreName
        label.font = TextStyle.light
        label.textColor = .systemBackground
        label.backgroundColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: label.intrinsicContentSize.width + Spacing.medium).isActive = true
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingMiddle
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }

    static func createImageView(contentMode: UIView.ContentMode = .scaleAspectFill, cornerRadius: CGFloat = 0, backgroundColor: UIColor = .systemGray3) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.backgroundColor = backgroundColor
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    static func createPosterImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }

    static func createShadowView() -> UIView {
        let shadowView = UIView()
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowView.layer.shadowRadius = 12
        shadowView.layer.shadowOpacity = 0.2
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        return shadowView
    }

    static func createContainerView(cornerRadius: CGFloat = 20, backgroundColor: UIColor = .secondarySystemGroupedBackground) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
    
    static func createContentStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let contentStackView = UIStackView(arrangedSubviews: arrangedSubviews)
        contentStackView.axis = .vertical
        contentStackView.spacing = Spacing.medium
        contentStackView.alignment = .leading
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        return contentStackView
    }
}
