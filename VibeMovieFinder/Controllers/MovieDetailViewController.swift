import UIKit

final class MovieDetailViewController: UIViewController {
    private let movieCollectionView = MovieDetailSectionsView()
    private let viewModel: MovieDetailSectionsViewViewModel
    
    init(movie: Movie) {
        self.viewModel = MovieDetailSectionsViewViewModel(movie: movie)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func loadView() {
        super.loadView()
        configureView()
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        navigationItem.title = ""

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapShare)
        )
    }

    @objc
    private func didTapShare() {
        // Share movie info
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
}

// MARK: - MovieDetailViewModelDelegate

extension MovieDetailViewController: MovieDetailSectionsViewViewModelDelegate {
    func didFetchMovieDetails() {
        movieCollectionView.configure(with: viewModel)
    }
}
