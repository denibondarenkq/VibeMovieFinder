import UIKit

class VibeButtonCell: UICollectionViewCell {
    
    static let identifier = "VibeButtonCollectionViewCell"
    
    private var isFilled = false
    private var randomColor: UIColor = .systemBlue
    var onButtonTapped: (() -> Void)?
    
    private let defaultButtonView = DefaultButtonView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(defaultButtonView)
        defaultButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            defaultButtonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            defaultButtonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            defaultButtonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            defaultButtonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        defaultButtonView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configure(with title: String, isFilled: Bool) {
        self.isFilled = isFilled
        updateButtonAppearance(with: title)
    }
    
    @objc private func buttonTapped() {
        isFilled.toggle()
        if isFilled {
            randomColor = generateRandomSystemColor()
        }
        let title = defaultButtonView.button.titleLabel?.text ?? ""
        updateButtonAppearance(with: title)
        onButtonTapped?()
    }
    
    private func updateButtonAppearance(with title: String) {
        let backgroundColor = isFilled ? randomColor : UIColor.secondarySystemGroupedBackground
        let titleColor = isFilled ? UIColor.white : UIColor.label
        defaultButtonView.configure(title: title, backgroundColor: backgroundColor, titleColor: titleColor)
    }
    
    private func generateRandomSystemColor() -> UIColor {
        let systemColors: [UIColor] = [
            .systemRed, .systemGreen, .systemBlue, .systemOrange,
            .systemYellow, .systemPink, .systemPurple, .systemTeal,
            .systemIndigo, .systemBrown, .systemCyan, .systemMint,
        ]
        return systemColors.randomElement() ?? .systemBlue
    }
}
