import UIKit

class DefaultButtonView: UIView {

    let shadowView = ShadowView() // Сделать доступным для подклассов
    let button = UIButton(type: .system) // Сделать доступным для подклассов

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

        // Создание конфигурации кнопки
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: Spacing.medium, leading: Spacing.medium, bottom: Spacing.medium, trailing: Spacing.medium)

        // Установка стиля текста
        configuration.attributedTitle = AttributedString("Button Title", attributes: AttributeContainer([.font: TextStyle.heading2]))

        button.configuration = configuration

        shadowView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: shadowView.topAnchor),
            button.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
        ])
    }

    // Функция для настройки названия кнопки, цвета и других параметров
    func configure(title: String, backgroundColor: UIColor = .systemBlue, titleColor: UIColor = .white) {
        var configuration = button.configuration
        configuration?.baseBackgroundColor = backgroundColor
        configuration?.baseForegroundColor = titleColor
        configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: TextStyle.heading2]))
        button.configuration = configuration
    }

    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button.addTarget(target, action: action, for: controlEvents)
    }
}
