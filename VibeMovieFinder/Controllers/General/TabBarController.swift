import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let chatVC = VibesMoviesViewController(viewModel: VibesMoviesViewModel())
        let watchlistVC = AccountMoviesViewController(viewModel: PaginatedMoviesViewModel(), endpoint: .accountWatchlistMovies, title: "Watchlist")
        let ratedMoviesVC = AccountMoviesViewController(viewModel: PaginatedMoviesViewModel(), endpoint: .accountRatedMovies, title: "Rated")
        let searchMoviesVC = SearchMoviesViewController(viewModel: PaginatedMoviesViewModel(), title: "Search")
        
        let viewControllers = [
            createNavController(for: watchlistVC, title: "Watchlist", image: "square.3.layers.3d.down.left"),
            createNavController(for: chatVC, title: "AIFinder", image: "bubbles.and.sparkles"),
            createNavController(for: ratedMoviesVC, title: "Rated", image: "star"),
            createNavController(for: searchMoviesVC, title: "Search", image: "magnifyingglass")
        ]
        
        setViewControllers(viewControllers, animated: true)
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: image)
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.largeTitleDisplayMode = .automatic
        return navController
    }
}
