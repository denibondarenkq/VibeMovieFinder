import UIKit

class PaginatedMoviesViewController: MoviesViewController {
    
    var paginatedViewModel: PaginatedMoviesViewModelProtocol {
        guard let viewModel = viewModel as? PaginatedMoviesViewModelProtocol else {
            fatalError("ViewModel must be of type PaginatedMoviesListViewModelProtocol")
        }
        return viewModel
    }
    
    private let refreshControl = UIRefreshControl()

    init(viewModel: PaginatedMoviesViewModelProtocol) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollListener()
        setupRefreshControl()
        fetchInitialData()
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        movieTableView.tableView.refreshControl = refreshControl
    }

    @objc private func didPullToRefresh() {
        paginatedViewModel.fetchMoviesAndGenres(page: 1) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                switch result {
                case .success:
                    self.movieTableView.tableView.reloadData()
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    private func setupScrollListener() {
        movieTableView.tableView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            handleScroll()
        }
    }

    private func handleScroll() {
        let contentOffsetY = movieTableView.tableView.contentOffset.y
        let contentHeight = movieTableView.tableView.contentSize.height
        let frameHeight = movieTableView.tableView.frame.size.height

        if contentOffsetY > contentHeight - frameHeight - 100 {
            if paginatedViewModel.hasMorePages {
                showLoadingFooter()
                paginatedViewModel.fetchNextPage()
            }
        }
    }

    private func showLoadingFooter() {
        let footer = SpinnerView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        movieTableView.tableView.tableFooterView = footer
    }

    private func fetchInitialData() {
        paginatedViewModel.fetchMoviesAndGenres(page: 1) { [weak self] result in
            switch result {
            case .success:
                self?.didFetchMovies()
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
}
