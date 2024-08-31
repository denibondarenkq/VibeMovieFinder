import UIKit

class VibeListViewController: MoviesListViewController {
    
    private let findMoviesButton = DefaultButtonView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let loadingLabel = UILabel()

    init(viewModel: VibeListViewModel) {
        super.init(viewModel: viewModel)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AIFinder"
        updateFindMoviesButtonVisibility()
    }
    
    private func setupView() {
        view.addSubview(findMoviesButton)
        findMoviesButton.configure(title: "Find My Movies by Vibe")
        findMoviesButton.addTarget(self, action: #selector(findMoviesButtonTapped), for: .touchUpInside)

        // Добавляем индикатор загрузки
        view.addSubview(loadingIndicator)
        loadingIndicator.color = .gray
        loadingIndicator.hidesWhenStopped = true
        
        // Добавляем текст загрузки
        view.addSubview(loadingLabel)
        loadingLabel.text = "Gemini AI is working on your request..."
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.font = UIFont.systemFont(ofSize: 16)
        loadingLabel.isHidden = true

        setupConstraints()
    }
    
    private func setupConstraints() {
        findMoviesButton.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            findMoviesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findMoviesButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 10),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func updateFindMoviesButtonVisibility() {
        findMoviesButton.isHidden = !(viewModel.movieCellViewModels.isEmpty)
    }

    @objc private func findMoviesButtonTapped() {
        let vibeConfigVC = VibeConfigurationViewController()
        vibeConfigVC.delegate = self
        present(vibeConfigVC, animated: true)
    }

    private func setupRetryVibeButton() {
        DispatchQueue.main.async {
            let retryVibeButton = UIBarButtonItem(
                image: UIImage(systemName: "arrow.triangle.2.circlepath"),
                style: .plain,
                target: self,
                action: #selector(self.retryVibeButtonTapped)
            )
            self.navigationItem.rightBarButtonItem = retryVibeButton
        }
    }

    @objc private func retryVibeButtonTapped() {
        let vibeConfigVC = VibeConfigurationViewController()
        vibeConfigVC.delegate = self
        present(vibeConfigVC, animated: true)
    }
}

// MARK: - VibeConfigurationDelegate

extension VibeListViewController: VibeConfigurationDelegate {
    func didSelectVibes(_ selectedVibes: [String]) {
        findMoviesButton.isHidden = true // Скрываем основную кнопку

        // Показываем индикатор загрузки и текст в главном потоке
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.loadingLabel.isHidden = false
        }
        
        (viewModel as? VibeListViewModel)?.fetchMoviesBasedOnVibes(selectedVibes) { [weak self] result in
            // Прячем индикатор загрузки и текст в главном потоке
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.loadingLabel.isHidden = true
            }

            switch result {
            case .success:
                self?.didFetchMovies()
                self?.setupRetryVibeButton() // Добавляем кнопку "Retry Vibes" после успешного поиска
            case .failure(let error):
                self?.handleError(error)
                self?.updateFindMoviesButtonVisibility() // Показываем кнопку поиска в случае ошибки
            }
        }
    }
    
    func didFailToFetchVibes(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true) {
                self?.handleError(error)
                self?.updateFindMoviesButtonVisibility()
            }
        }
    }
}
