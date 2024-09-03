import UIKit

protocol MoviesTableViewDelegate: AnyObject {
    func movieDetailView(_ movieTableView: MoviesTableView, didSelect movie: Movie)
}

class MoviesTableView: UIView {
    weak var delegate: MoviesTableViewDelegate?
    private var viewModel: MoviesViewModelProtocol? {
        didSet {
            updateView()
        }
    }
    
    private let loadingSpinnerView: SpinnerView = {
        let spinner = SpinnerView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        return refreshControl
    }()
    
    public let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.alpha = 0
        table.estimatedRowHeight = MovieTableViewCell.cellHeight
        table.isHidden = true
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellIdentifier)
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(named: "BackgroundColor")
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        addSubview(loadingSpinnerView)
        loadingSpinnerView.startAnimating()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingSpinnerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingSpinnerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func configure(with viewModel: MoviesViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    private func updateView() {
        loadingSpinnerView.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
    }
}
// MARK: - UITableViewDataSource

extension MoviesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.movieCellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellIdentifier, for: indexPath) as? MovieTableViewCell else {
            fatalError("Unable to dequeue MovieTableViewCell")
        }
        guard let cellViewModels = viewModel?.movieCellViewModels else {
            fatalError("IndexPath out of range for cellViewModels")
        }
        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MoviesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = viewModel?.movie(at: indexPath.row) else { return }
        delegate?.movieDetailView(self, didSelect: movie)
    }
}
