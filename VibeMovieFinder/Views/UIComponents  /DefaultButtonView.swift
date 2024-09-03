import UIKit

class DefaultButtonView: UIView {
    
    private let shadowView: UIView = UIComponentFactory.createShadowView()
    let button = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setupShadowView()
        setupButton()
    }
    
    private func setupShadowView() {
        addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupButton() {
        shadowView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: shadowView.topAnchor),
            button.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
        ])
    }
    
    func configure(title: String, backgroundColor: UIColor = .systemBlue, titleColor: UIColor = .white) {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = backgroundColor
        configuration.baseForegroundColor = titleColor
        configuration.contentInsets = NSDirectionalEdgeInsets(top: Spacing.medium, leading: Spacing.medium, bottom: Spacing.medium, trailing: Spacing.medium)
        configuration.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: TextStyle.heading2]))
        button.configuration = configuration
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button.addTarget(target, action: action, for: controlEvents)
    }
}
