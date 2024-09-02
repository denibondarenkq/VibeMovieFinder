import UIKit

class AccountMoviesListViewController: PaginatedMoviesListViewController {
    
    private let screenTitle: String
    
    init(viewModel: PaginatedMoviesListViewModel, endpoint: Endpoint, title: String) {
        self.screenTitle = title
        super.init(viewModel: viewModel)
        viewModel.configure(endpoint: endpoint, initialParameters: ["sort_by": "created_at.desc"])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = screenTitle
        setupSortButton()
        setupLogoutButton()
    }
    
    private func setupSortButton() {
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(promptSortOrder))
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupLogoutButton() {
        let logoutIcon = UIImage(systemName: "door.right.hand.open")
        let logoutButton = UIBarButtonItem(image: logoutIcon, style: .plain, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc private func promptSortOrder() {
        let alert = UIAlertController(title: "Sort By Date Added", message: "Choose the order for sorting movies by their date added", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Oldest First", style: .default, handler: { [weak self] _ in
            if let paginatedViewModel = self?.viewModel as? PaginatedMoviesListViewModelProtocol {
                paginatedViewModel.updateRequestParameters(["sort_by": "created_at.asc"])
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Newest First", style: .default, handler: { [weak self] _ in
            if let paginatedViewModel = self?.viewModel as? PaginatedMoviesListViewModelProtocol {
                paginatedViewModel.updateRequestParameters(["sort_by": "created_at.desc"])
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func logout() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { [weak self] _ in
            self?.logoutUser()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func logoutUser() {
        SessionManager.shared.deleteSession { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = scene.windows.first else {
                        return
                    }

                    let authViewController = AuthViewController()
                    window.rootViewController = authViewController
                    UIView.transition(with: window,
                                      duration: 0.5,
                                      options: [.transitionFlipFromRight],
                                      animations: nil,
                                      completion: nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.handleError(error)
                }
            }
        }
    }
}
