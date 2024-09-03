import UIKit

protocol MovieDetailSectionsViewDelegate: AnyObject {
    func movieDetailSectionsView(_ view: MovieDetailSectionsView, didSelectMovie movie: Movie)
    func movieDetailSectionsView(_ view: MovieDetailSectionsView, didSelectText text: String)
}
final class MovieDetailSectionsView: UIView {
    weak var delegate: MovieDetailSectionsViewDelegate?
    private var collectionView: UICollectionView?
    private var viewModel: MovieDetailSectionsViewViewModel? {
        didSet {
            updateView()
        }
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        collectionView = createCollectionView()
        addSubview(collectionView!)
        addSubview(activityIndicator)
        setupConstraints()
        activityIndicator.startAnimating()
    }
    
    private func setupConstraints() {
        guard let collectionView = collectionView else { return }
        
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            self?.createSectionLayout(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "BackgroundColor")
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCells(for: collectionView)
        
        return collectionView
    }
    private func registerCells(for collectionView: UICollectionView) {
        collectionView.register(BackdropCollectionViewCell.self, forCellWithReuseIdentifier: BackdropCollectionViewCell.cellIdentifer)
        collectionView.register(OverviewCollectionViewCell.self, forCellWithReuseIdentifier: OverviewCollectionViewCell.cellIdentifier)
        collectionView.register(FactCollectionViewCell.self, forCellWithReuseIdentifier: FactCollectionViewCell.cellIdentifier)
        collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.cellIdentifier)
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.cellIdentifier)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.cellIdentifier)
        collectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.cellIdentifier)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.cellIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
    }
    
    private func updateView() {
        activityIndicator.stopAnimating()
        collectionView?.reloadData()
        collectionView?.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.collectionView?.alpha = 1
        }
    }
    
    public func configure(with viewModel: MovieDetailSectionsViewViewModel) {
        self.viewModel = viewModel
    }
    
    private func createSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.sections, sectionIndex < sections.count else {
            return BackdropSectionLayoutStrategy().createSectionLayout()
        }
        
        let sectionType = sections[sectionIndex]
        
        let strategy: SectionLayoutStrategy
        
        switch sectionType {
        case .backdrop:
            strategy = BackdropSectionLayoutStrategy()
        case .facts:
            strategy = DefaultSectionLayoutStrategy(groupWidth: .absolute(100), groupHeight: .absolute(80))
        case .overview:
            strategy = DefaultSectionLayoutStrategy(groupWidth: .absolute(350), groupHeight: .absolute(130))
        case .genres:
            strategy = DefaultSectionLayoutStrategy(groupWidth: .absolute(150), groupHeight: .absolute(30))
        case .cast:
            strategy = DefaultSectionLayoutStrategy(groupWidth: .absolute(120), groupHeight: .absolute(180))
        case .images:
            strategy = DefaultSectionLayoutStrategy(groupWidth: .absolute(230), groupHeight: .absolute(130))
        case .reviews:
            strategy = DefaultSectionLayoutStrategy(groupWidth: .absolute(350), groupHeight: .absolute(180))
        case .recommendations:
            strategy = DefaultSectionLayoutStrategy(groupWidth: .absolute(230), groupHeight: .absolute(180))
        }
        
        return strategy.createSectionLayout()
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MovieDetailSectionsView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = viewModel?.sections[section] else {
            return 0
        }
        
        switch sectionType {
        case .facts(let viewModels):
            return viewModels.count
        case .overview(let viewModels):
            return viewModels.count
        case .cast(let viewModels):
            return viewModels.count
        case .genres(let viewModels):
            return viewModels.count
        case .images(let viewModels):
            return viewModels.count
        case .reviews(let viewModels):
            return viewModels.count
        case .recommendations(let viewModels):
            return viewModels.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = viewModel?.sections[indexPath.section] else {
            fatalError("No section available")
        }
        
        switch sectionType {
        case .backdrop(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BackdropCollectionViewCell.cellIdentifer,
                for: indexPath
            ) as? BackdropCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        case .facts(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FactCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? FactCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .overview(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OverviewCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? OverviewCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .genres(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GenreCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? GenreCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .cast(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? CastCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .images(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? ImageCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .reviews(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ReviewCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? ReviewCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .recommendations(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? MovieCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
        
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Invalid supplementary view kind")
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? SectionHeaderView else {
            fatalError("Could not dequeue SectionHeaderView")
        }
        
        guard let section = viewModel?.sections[indexPath.section] else {
            fatalError("No section available")
        }
        
        switch section {
        case .facts:
            header.configure(with: viewModel!.title)
        case .genres:
            header.configure(with: "Genres")
        case .overview:
            header.configure(with: "Overview")
        case .cast:
            header.configure(with: "Top Billed Cast")
        case .images:
            header.configure(with: "Images")
        case .reviews:
            header.configure(with: "Comments")
        case .recommendations:
            header.configure(with: "You might also like")
        default:
            header.configure(with: " ")
        }

        return header
    }
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let sectionType = viewModel?.sections[indexPath.section] else {
                return
            }

            switch sectionType {
            case .overview(let viewModels):
                let overview = viewModels[indexPath.row].descriptionText
                delegate?.movieDetailSectionsView(self, didSelectText: overview)
                
            case .reviews(let viewModels):
                let review = viewModels[indexPath.row].content
                delegate?.movieDetailSectionsView(self, didSelectText: review)

            case .recommendations:
                guard let movie = viewModel?.recommendation(at: indexPath.row) else { return }
                delegate?.movieDetailSectionsView(self, didSelectMovie: movie)
                
            default:
                break
            }
        }
    
}
