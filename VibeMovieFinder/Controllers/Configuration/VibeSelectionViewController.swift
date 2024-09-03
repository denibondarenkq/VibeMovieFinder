import UIKit

protocol VibeSelectionViewControllerDelegate: AnyObject {
    func didSelectVibes(_ selectedVibes: [String])
    func didFailToFetchVibes(_ error: Error)
}

class VibeSelectionViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let viewModel = VibeSelectionViewModel()
    private var filledButtons: [Bool] = []
    
    weak var delegate: VibeSelectionViewControllerDelegate?
    private let goButtonView = DefaultButtonView()
    
    private let titleLabel: UILabel = {
        let label = UIComponentFactory.createLabel(font: TextStyle.heading1, textColor: .label, numberOfLines: 1, textAlignment: .center)
        label.text = "Let's find your vibe!"
        return label
    }()
    
    private let loadingSpinnerView: SpinnerView = {
        let spinner = SpinnerView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        setupTitleLabel()
        setupCollectionView()
        setupGoButtonView()
        setupSpinnerView()
        loadData()
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.large),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.medium),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.medium)
        ])
    }
    
    private func setupCollectionView() {
        let layout = CenteredVibeButtonFlowLayout()
        layout.minimumInteritemSpacing = Spacing.medium
        layout.minimumLineSpacing = Spacing.medium
        layout.sectionInset = UIEdgeInsets(top: Spacing.large, left: Spacing.large, bottom: Spacing.large, right: Spacing.large)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(VibeButtonCell.self, forCellWithReuseIdentifier: VibeButtonCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.medium),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupGoButtonView() {
        view.addSubview(goButtonView)
        goButtonView.configure(title: "Generate My List")
        goButtonView.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        
        goButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.large),
            goButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupSpinnerView() {
        view.addSubview(loadingSpinnerView)
        NSLayoutConstraint.activate([
            loadingSpinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingSpinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadData() {
        loadingSpinnerView.startAnimating()
        viewModel.loadButtonTitles { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loadingSpinnerView.stopAnimating()
                switch result {
                case .success:
                    self.filledButtons = Array(repeating: false, count: self.viewModel.buttonTitles.count)
                    self.collectionView.reloadData()
                case .failure(let error):
                    self.delegate?.didFailToFetchVibes(error)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func goButtonTapped() {
        let selectedVibes = viewModel.getSelectedVibes(filledButtons: filledButtons)
        delegate?.didSelectVibes(selectedVibes)
        dismiss(animated: true, completion: nil)
    }
}

extension VibeSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.buttonTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VibeButtonCell.identifier, for: indexPath) as? VibeButtonCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.buttonTitles[indexPath.row], isFilled: filledButtons[indexPath.row])
        cell.onButtonTapped = { [weak self] in
            self?.filledButtons[indexPath.row].toggle()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = viewModel.buttonTitles[indexPath.row]
        let padding: CGFloat = Spacing.large + Spacing.small
        let buttonHeight: CGFloat = Spacing.large * 2
        let size = title.size(withAttributes: [NSAttributedString.Key.font: TextStyle.heading2])
        return CGSize(width: size.width + padding, height: buttonHeight)
    }
}
