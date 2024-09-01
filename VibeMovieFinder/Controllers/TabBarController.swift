import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAppearance()
        setupTabBar()
    }
    
    private func setupAppearance() {
        view.backgroundColor = .yellow
    }
    
    private func setupTabBar() {
        let chatVC = VibeListViewController(viewModel: VibeListViewModel())
        
        let watchlistVC = AccountMoviesListViewController(viewModel: PaginatedMoviesListViewModel(), endpoint: Endpoint.accountWatchlistMovies, title: "Watchlist")
        
        let ratedMoviesVC = AccountMoviesListViewController(viewModel: PaginatedMoviesListViewModel(), endpoint: Endpoint.accountRatedMovies, title: "Rated")
        
        let searchMoviesVC = SearchMoviesViewController(viewModel: PaginatedMoviesListViewModel(), query: "", releaseYear: "", title: "Search")
        
        watchlistVC.navigationItem.largeTitleDisplayMode = .automatic
        chatVC.navigationItem.largeTitleDisplayMode = .automatic
        ratedMoviesVC.navigationItem.largeTitleDisplayMode = .automatic
        searchMoviesVC.navigationItem.largeTitleDisplayMode = .automatic

        
        let nav1 = UINavigationController(rootViewController: watchlistVC)
        let nav2 = UINavigationController(rootViewController: chatVC)
        let nav3 = UINavigationController(rootViewController: ratedMoviesVC)
        let nav4 = UINavigationController(rootViewController: searchMoviesVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Watchlist", image: UIImage(systemName: "square.3.layers.3d.down.left"), tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "AIFinder", image: UIImage(systemName: "bubbles.and.sparkles"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Rated", image: UIImage(systemName: "star"), tag: 2)
        nav4.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)

        
        [nav1, nav2, nav3, nav4].forEach { nav in
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }
}
