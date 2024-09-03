import UIKit

final class MovieTableViewCell: UITableViewCell {
    static let cellHeight: CGFloat = 190
    static let cellIdentifier = "MovieTableViewCell"
    
    private let nameLabel: UILabel
    private let ratingLabel: UILabel
    private let genresStackView: UIStackView
    private let yearLabel: UILabel
    private let verdictLabel: UILabel
    private let movieImageView: UIImageView
    
    private let contentStackView: UIStackView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.nameLabel = UIComponentFactory.createTitleLabel()
        self.ratingLabel = UIComponentFactory.createRegularLabel()
        self.genresStackView = UIComponentFactory.createStackView(axis: .horizontal, alignment: .leading, distribution: .fillProportionally, spacing: Spacing.small)
        self.yearLabel = UIComponentFactory.createRegularLabel()
        self.verdictLabel = UIComponentFactory.createRegularLabel()
        self.movieImageView = UIComponentFactory.createPosterImageView()
        self.contentStackView = UIComponentFactory.createContentStackView(arrangedSubviews: [nameLabel, ratingLabel, verdictLabel, yearLabel, genresStackView])
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustStackViewVisibility()
    }
    
    private func setupViews() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(contentStackView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.large),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.large),
            movieImageView.widthAnchor.constraint(equalToConstant: 100),
            movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 1.5),
            
            contentStackView.centerYAnchor.constraint(equalTo: movieImageView.centerYAnchor),
            contentStackView.leftAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: Spacing.medium),
            contentStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Spacing.large),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        ratingLabel.text = nil
        verdictLabel.text = nil
        genresStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        yearLabel.text = nil
        movieImageView.image = nil
    }
    
    public func configure(with viewModel: MovieTableViewCellViewModel) {
        nameLabel.text = viewModel.title
        ratingLabel.text = "⭐ \(viewModel.rating)/10 TMDB"
        yearLabel.text = "🗓️ \(viewModel.releaseYear)"
        
        if let verdict = viewModel.verdict {
            verdictLabel.text = "🧑‍⚖️ \(verdict)/10 Your verdict"
            verdictLabel.isHidden = false
        } else {
            verdictLabel.isHidden = true
        }
        
        for genre in viewModel.genreNames {
            let genreLabel = UIComponentFactory.createGenreLabel(for: genre)
            genresStackView.addArrangedSubview(genreLabel)
        }
        
        viewModel.fetchPosterImage() { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.movieImageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    private func adjustStackViewVisibility() {
        var totalWidth: CGFloat = 0.0
        let maxWidth = contentView.frame.width / 2
        
        for view in genresStackView.arrangedSubviews {
            guard let label = view as? UILabel else { continue }
            
            let labelWidth = label.intrinsicContentSize.width + Spacing.medium
            if totalWidth + labelWidth >= maxWidth {
                label.isHidden = true
            } else {
                label.isHidden = false
                totalWidth += labelWidth + genresStackView.spacing
            }
        }
    }
}
