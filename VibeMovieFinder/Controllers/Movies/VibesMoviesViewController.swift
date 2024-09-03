import UIKit

class VibesMoviesViewController: MoviesViewController {
    
    private let findMoviesButton = DefaultButtonView()
    private let loadingLabel = UILabel()

    init(viewModel: VibesMoviesViewModel) {
        super.init(viewModel: viewModel)
        setupView()
    }
    
    private let loadingSpinnerView: SpinnerView = {
        let spinner = SpinnerView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

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

        view.addSubview(loadingSpinnerView)
        loadingSpinnerView.stopAnimating()

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
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            findMoviesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findMoviesButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loadingSpinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingSpinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            loadingLabel.topAnchor.constraint(equalTo: loadingSpinnerView.bottomAnchor, constant: 10),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func updateFindMoviesButtonVisibility() {
        findMoviesButton.isHidden = !(viewModel.movieCellViewModels.isEmpty)
    }

    @objc private func findMoviesButtonTapped() {
        let vibeConfigVC = VibeSelectionViewController()
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
        let vibeConfigVC = VibeSelectionViewController()
        vibeConfigVC.delegate = self
        present(vibeConfigVC, animated: true)
    }
}

// MARK: - VibeConfigurationDelegate

extension VibesMoviesViewController: VibeSelectionViewControllerDelegate {
    func didSelectVibes(_ selectedVibes: [String]) {
        findMoviesButton.isHidden = true

        DispatchQueue.main.async {
            self.loadingSpinnerView.startAnimating()
            self.loadingLabel.isHidden = false
        }
        
        (viewModel as? VibesMoviesViewModel)?.fetchMoviesBasedOnVibes(selectedVibes) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingSpinnerView.stopAnimating()
                self?.loadingLabel.isHidden = true
            }

            switch result {
            case .success:
                self?.didFetchMovies()
                self?.setupRetryVibeButton()
            case .failure(let error):
                self?.handleError(error)
                self?.updateFindMoviesButtonVisibility()
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
