import UIKit

final class MovieDetailViewController: UIViewController {
    
    private let movieCollectionView = MovieDetailSectionsView()
    private let viewModel: MovieDetailViewModel
    
    private var ratingButton: UIBarButtonItem?
    private var watchlistButton: UIBarButtonItem?
        
    init(movie: Movie) {
        self.viewModel = MovieDetailViewModel(movie: movie)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        configureNavigationBar()
        setupDelegates()
        viewModel.fetchContent()
    }
        
    private func setupView() {
        title = viewModel.title
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(movieCollectionView)
    }
    
    private func setupConstraints() {
        movieCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            movieCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureNavigationBar() {
        ratingButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(didTapRatingButton))
        watchlistButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(didTapWatchlistButton))
        navigationItem.rightBarButtonItems = [watchlistButton!, ratingButton!]
        updateWatchlistButton()
        updateRatingButton()
    }
    
    private func setupDelegates() {
        viewModel.delegate = self
        movieCollectionView.delegate = self
    }
        
    @objc private func didTapRatingButton() {
        presentRatingAlertController()
    }

    @objc private func didTapWatchlistButton() {
        toggleWatchlist()
    }
        
    private func updateWatchlistButton() {
        let watchlistImageName = viewModel.isInWatchlist ? "bookmark.fill" : "bookmark"
        watchlistButton?.image = UIImage(systemName: watchlistImageName)
    }
    
    private func updateRatingButton() {
        let ratingImageName = viewModel.isRated ? "star.fill" : "star"
        ratingButton?.image = UIImage(systemName: ratingImageName)
    }
        
    private func presentRatingAlertController() {
        let alertController = UIAlertController(title: "Rate Movie", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.keyboardType = .decimalPad
            textField.placeholder = "Enter rating (0.5 - 10.0)"
        }

        let rateAction = UIAlertAction(title: "Rate", style: .default) { [weak self, weak alertController] _ in
            guard let self = self else { return }
            guard let ratingText = alertController?.textFields?.first?.text,
                  let ratingValue = Double(ratingText), ratingValue >= 0.5 && ratingValue <= 10.0 else {
                return
            }
            self.viewModel.rateMovie(with: ratingValue)
        }

        let removeRatingAction = UIAlertAction(title: "Remove Rating", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.removeRating()
        }

        alertController.addAction(rateAction)
        alertController.addAction(removeRatingAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func toggleWatchlist() {
        let isInWatchlist = viewModel.isInWatchlist
        viewModel.toggleWatchlist(isAdding: !isInWatchlist)
    }
    
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkService.NetworkServiceError {
            switch networkError {
            case .invalidSession:
                showAuthorizationController()
            default:
                showErrorAlert(message: error.localizedDescription)
            }
        } else {
            showErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func showAuthorizationController() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return
        }
        let authViewController = AuthViewController()
        window.rootViewController = authViewController
        UIView.transition(with: window, duration: 0.5, options: [.transitionFlipFromRight], animations: nil, completion: nil)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    private func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - MovieDetailViewModelDelegate

extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func didFetchMovieDetails() {
        DispatchQueue.main.async {
            self.movieCollectionView.configure(with: self.viewModel)
            self.updateWatchlistButton()
            self.updateRatingButton()
        }
    }
    
    func didUpdateMovieState() {
        DispatchQueue.main.async {
            self.updateWatchlistButton()
            self.updateRatingButton()
            self.showSuccessAlert(message: "Movie state updated!")
        }
    }
    
    func didFailToFetch(with error: Error) {
        DispatchQueue.main.async {
            self.handleError(error)
        }
    }
}

// MARK: - MovieDetailSectionsViewDelegate

extension MovieDetailViewController: MovieDetailSectionsViewDelegate {
    func movieDetailSectionsView(_ view: MovieDetailSectionsView, didSelectText text: String) {
        let fullScreenVC = FullScreenTextViewController(text: text)
        let navController = UINavigationController(rootViewController: fullScreenVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    func movieDetailSectionsView(_ view: MovieDetailSectionsView, didSelectMovie movie: Movie) {
        let movieDetailVC = MovieDetailViewController(movie: movie)
        movieDetailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
