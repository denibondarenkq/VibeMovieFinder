import UIKit

class AccountMoviesListViewController: MoviesListViewController {
    private let screenTitle: String

    init(endpoint: Endpoint, title: String) {
        self.screenTitle = title
        let viewModel = MoviesTableViewViewModel()
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
    }
    
    private func setupSortButton() {
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(promptSortOrder))
        navigationItem.rightBarButtonItem = sortButton
    }

    @objc private func promptSortOrder() {
        let alert = UIAlertController(title: "Sort By", message: "Date Added", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ascending", style: .default, handler: { _ in
//            self.viewModel.updateSortOrder(to: "created_at.asc")
        }))
        alert.addAction(UIAlertAction(title: "Descending", style: .default, handler: { _ in
//            self.viewModel.updateSortOrder(to: "created_at.desc")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
