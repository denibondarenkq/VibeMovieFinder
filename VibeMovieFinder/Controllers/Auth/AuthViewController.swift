import UIKit
import SafariServices

class AuthViewController: UIViewController {

    private let viewModel = AuthViewModel()

    private let welcomeLabel: UILabel = {
        let label = UIComponentFactory.createLabel(
            font: TextStyle.heading1,
            textColor: .label,
            textAlignment: .center
        )
        label.text = "Welcome!"
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UIComponentFactory.createLabel(
            font: TextStyle.body,
            textColor: .label,
            numberOfLines: 0,
            textAlignment: .center
        )
        label.text = "Welcome to Vibe Movie Finder! Sign in to continue."
        return label
    }()

    private let signInButtonView: DefaultButtonView = {
        let buttonView = DefaultButtonView()
        buttonView.configure(title: "Sign In")
        return buttonView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupConstraints()
        viewModel.delegate = self        
        signInButtonView.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }

    private func configureView() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(welcomeLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(signInButtonView)
    }

    private func setupConstraints() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        signInButtonView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.large*2),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: Spacing.large),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.large),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.large),

            signInButtonView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Spacing.large*2),
            signInButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.large),
            signInButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.large),
            signInButtonView.heightAnchor.constraint(equalToConstant: Spacing.large*2)
        ])
    }

    @objc private func signInButtonTapped() {
        viewModel.startAuthorization()
    }
}

// MARK: - AuthViewModelDelegate

extension AuthViewController: AuthViewModelDelegate, SFSafariViewControllerDelegate {
    func didReceiveAuthURL(_ url: URL) {
        DispatchQueue.main.async {
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        viewModel.createSession()
    }

    func didAuthorizeSuccessfully() {
        DispatchQueue.main.async {
            let tabBarVC = TabBarController()
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    window.rootViewController = tabBarVC
                    window.makeKeyAndVisible()
                }
            }
        }
    }

    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
