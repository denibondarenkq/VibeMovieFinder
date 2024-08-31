import UIKit

class MoviesListViewController: UIViewController {
    let movieTableView = MoviesTableView()
    let viewModel: MoviesListViewModelProtocol
    
    init(viewModel: MoviesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        configureView()
        setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func configureView() {
        view.addSubview(movieTableView)
        view.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    private func setupConstraints() {
        movieTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.delegate = self
        movieTableView.delegate = self
        
        movieTableView.configure(with: viewModel)
    }
    
    func handleError(_ error: Error) {
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
}

// MARK: - MovieTableViewDelegate

extension MoviesListViewController: MoviesTableViewDelegate {
    func movieDetailView(_ movieTableView: MoviesTableView, didSelect movie: Movie) {
        let vc = MovieDetailViewController(movie: movie)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - BaseMoviesViewModelDelegate

extension MoviesListViewController: MoviesTableViewModelDelegate {
    func didFetchMovies() {
        DispatchQueue.main.async {
            self.movieTableView.tableView.reloadData()
            self.movieTableView.tableView.tableFooterView = nil
        }
    }

    func didFailToFetchMovies(with error: Error) {
        DispatchQueue.main.async {
            self.handleError(error)
        }
    }
}

