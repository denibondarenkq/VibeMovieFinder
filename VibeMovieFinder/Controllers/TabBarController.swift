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
        //            let watchlistVC = MoviesListViewController()
        let chatVC = VibeListViewController(viewModel: VibeListViewModel())
        let profileVC = ProfileViewController()
        
        let watchlistVC = AccountMoviesListViewController(viewModel: PaginatedMoviesListViewModel(), endpoint: Endpoint.accountWatchlistMovies, title: "Watchlist")
        
        let ratedMoviesVC = AccountMoviesListViewController(viewModel: PaginatedMoviesListViewModel(), endpoint: Endpoint.accountRatedMovies, title: "Rated Movies")
        
        watchlistVC.navigationItem.largeTitleDisplayMode = .automatic
        chatVC.navigationItem.largeTitleDisplayMode = .automatic
        profileVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: watchlistVC)
        let nav2 = UINavigationController(rootViewController: chatVC)
        let nav3 = UINavigationController(rootViewController: ratedMoviesVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Watchlist", image: UIImage(systemName: "square.3.layers.3d.down.left"), tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "AIFinder", image: UIImage(systemName: "ellipsis.message"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        
        [nav1, nav2, nav3].forEach { nav in
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2, nav3], animated: true)
    }
}
