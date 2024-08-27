import UIKit
import SafariServices

class AuthViewController: UIViewController {

    private let viewModel = AuthViewModel()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.font = TextStyle.heading1
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to MovieGuru! Sign in to continue."
        label.font = TextStyle.body
        label.textAlignment = .center
        label.numberOfLines = 0
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
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            signInButtonView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            signInButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signInButtonView.heightAnchor.constraint(equalToConstant: 50)
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
