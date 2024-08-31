import UIKit

class SearchMoviesViewController: PaginatedMoviesListViewController {
    
    private let screenTitle: String
    
    init(viewModel: PaginatedMoviesListViewModel, query: String, releaseYear: String, title: String) {
        self.screenTitle = title
        super.init(viewModel: viewModel)
        viewModel.configure(endpoint: .searchMovie)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = screenTitle
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search Movies"
        navigationItem.titleView = searchBar
    }
}

// MARK: - UISearchBarDelegate

extension SearchMoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text, !query.isEmpty else { return }
        (self.viewModel as? PaginatedMoviesListViewModel)?.updateRequestParameters(["query": query])
    }
}
