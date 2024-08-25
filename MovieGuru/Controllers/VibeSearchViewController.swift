import UIKit
class VibeSearchViewController: UIViewController {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "найти фильмы по вайбу"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Погнали", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(messageLabel)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20)
        ])
        
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
    }
    
    @objc private func didTapStartButton() {
        let buttonSelectionVC = VibeConfigurationViewController()
        buttonSelectionVC.delegate = self
        
        // Настройка стиля презентации
        buttonSelectionVC.modalPresentationStyle = .pageSheet
        buttonSelectionVC.modalTransitionStyle = .coverVertical
        
        present(buttonSelectionVC, animated: true, completion: nil)
    }

}

//// MARK: - ButtonSelectionDelegate
//
//extension VibeSearchViewController: ButtonSelectionDelegate {
//    func didSelectButtons(_ buttons: [String]) {
//        // Обработка выбранных кнопок и переход к списку фильмов
//    }
//}

extension VibeSearchViewController: VibeConfigurationDelegate {
    func didSelectVibes(_ selectedVibes: [String]) {
        print("d")
        // Обновите интерфейс или модель данных на основе выбранных vibes
    }
    
//    // Перед переходом на VibeConfigurationViewController установите делегат
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vibeConfigVC = segue.destination as? VibeConfigurationViewController {
//            vibeConfigVC.delegate = self
//        }
//    }
}
