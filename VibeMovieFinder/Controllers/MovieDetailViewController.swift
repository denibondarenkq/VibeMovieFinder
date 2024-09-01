import UIKit

final class MovieDetailViewController: UIViewController {
    private let movieCollectionView = MovieDetailSectionsView()
    private let viewModel: MovieDetailSectionsViewViewModel
    
    private var ratingButton: UIBarButtonItem?
    private var watchlistButton: UIBarButtonItem?
    
    init(movie: Movie) {
        self.viewModel = MovieDetailSectionsViewViewModel(movie: movie)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupConstraints()
        configureNavigationBar()
        viewModel.delegate = self
        viewModel.fetchContent()
    }
    
    private func configureView() {
        title = viewModel.title
        view.addSubview(movieCollectionView)
        view.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    private func configureNavigationBar() {
        ratingButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(didTapRate))
        watchlistButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(didTapWatchlist))
        
        navigationItem.rightBarButtonItems = [watchlistButton!, ratingButton!]
        
        updateRatingButton()
        updateWatchlistButton()
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

    @objc private func didTapRate() {
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
                self.viewModel.rateMovie(movieId: self.viewModel.movie.id, value: ratingValue) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.showSuccessAlert(message: "Rating saved!")
                        case .failure(let error):
                            self.handleError(error)
                        }
                    }
                }
            }

            let removeRatingAction = UIAlertAction(title: "Remove Rating", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.removeRating(movieId: self.viewModel.movie.id) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.showSuccessAlert(message: "Rating removed!")
                        case .failure(let error):
                            self.handleError(error)
                        }
                    }
                }
            }

            alertController.addAction(rateAction)
            alertController.addAction(removeRatingAction)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }

    @objc private func didTapWatchlist() {
        let isInWatchlist = viewModel.movieAccountState?.watchlist ?? false
        viewModel.toggleWatchlist(mediaType: "movie", mediaId: viewModel.movie.id, watchlist: !isInWatchlist) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.updateWatchlistButton()
                    let message = isInWatchlist ? "Removed from Watchlist" : "Added to Watchlist"
                    self.showSuccessAlert(message: message)
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    private func updateWatchlistButton() {
        let isInWatchlist = viewModel.movieAccountState?.watchlist ?? false
        let watchlistImageName = isInWatchlist ? "bookmark.slash.fill" : "bookmark"
        watchlistButton?.image = UIImage(systemName: watchlistImageName)
    }
    
    private func updateRatingButton() {
        let isRated = viewModel.movieAccountState?.rated != nil
        let ratingImageName = isRated ? "star.slash.fill" : "star"
        ratingButton?.image = UIImage(systemName: ratingImageName)
    }
    
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkService.NetworkServiceError {
            switch networkError {
            case .invalidSession:
                DispatchQueue.main.async {
                    self.showAuthorizationController()
                }
            default:
                showErrorAlert(message: error.localizedDescription)
            }
        } else {
            showErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func showAuthorizationController() {
        let authViewController = AuthViewController()
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
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

// MARK: - MovieDetailSectionsViewViewModelDelegate

extension MovieDetailViewController: MovieDetailSectionsViewViewModelDelegate {
    func didFetchMovieDetails() {
        movieCollectionView.configure(with: viewModel)
        updateWatchlistButton()
        updateRatingButton()
    }
    
    func didUpdateMovieState() {
        updateWatchlistButton()
        updateRatingButton()
    }
    
    func didFailToFetch(with error: Error) {
        DispatchQueue.main.async {
            self.handleError(error)
        }
    }
}
