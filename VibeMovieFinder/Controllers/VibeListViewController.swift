import UIKit

class VibeListViewController: MoviesListViewController {
    
    private let findMoviesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Find My Movies by Vibe", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(findMoviesButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init() {
        let viewModel = VibeListViewModel()
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        configureFindMoviesButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel.movieCellViewModels.isEmpty {
            displayFindMoviesButton()
        } else {
            hideFindMoviesButton()
        }
    }
    
    private func configureFindMoviesButton() {
        view.addSubview(findMoviesButton)
        NSLayoutConstraint.activate([
            findMoviesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findMoviesButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func displayFindMoviesButton() {
        findMoviesButton.isHidden = false
    }

    private func hideFindMoviesButton() {
        findMoviesButton.isHidden = true
    }

    @objc private func findMoviesButtonTapped() {
        let vibeConfigVC = VibeConfigurationViewController()
        vibeConfigVC.delegate = self
        present(vibeConfigVC, animated: true)
    }
}

// MARK: - VibeConfigurationDelegate

extension VibeListViewController: VibeConfigurationDelegate {
    func didSelectVibes(_ selectedVibes: [String]) {
        (viewModel as? VibeListViewModel)?.fetchMoviesBasedOnVibes(selectedVibes) { [weak self] result in
            switch result {
            case .success:
                self?.didFetchMovies()
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    func didFailWithError(_ error: Error) {
        dismiss(animated: true) { [weak self] in
            self?.handleError(error)
        }
    }
}
