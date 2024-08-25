import UIKit

class VibeButtonCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "VibeButtonCollectionViewCell"
    
    private var isFilled = false
    private var randomColor: UIColor = .systemBlue
    var onButtonTapped: (() -> Void)?
    
    private let defaultButtonView = DefaultButtonView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, isFilled: Bool) {
        defaultButtonView.configure(title: title)
        self.isFilled = isFilled
        updateButtonAppearance()
    }
    
    @objc private func buttonTapped() {
        isFilled.toggle()
        if isFilled {
            randomColor = generateRandomSystemColor()
        }
        updateButtonAppearance()
        onButtonTapped?()
    }
    
    private func updateButtonAppearance() {
        let title = defaultButtonView.button.titleLabel?.text ?? ""
        
        if isFilled {
            defaultButtonView.configure(title: title, backgroundColor: randomColor, titleColor: .white)
        } else {
            defaultButtonView.configure(title: title, backgroundColor: .secondarySystemGroupedBackground, titleColor: .label)
        }
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
