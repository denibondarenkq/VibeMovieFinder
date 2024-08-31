import UIKit
final class MovieTableViewCell: UITableViewCell {
    static let cellHeight: CGFloat = 190
    static let cellIdentifier = "MovieTableViewCell"
    
    private let nameLabel = UILabel.createTitleLabel()
    private let ratingLabel = UILabel.createRegularLabel()
    private let genresStackView = UIStackView.createStackView(axis: .horizontal, alignment: .leading, distribution: .fillProportionally, spacing: Spacing.small)
    private let yearLabel = UILabel.createRegularLabel()
    private let verdictLabel = UILabel.createRegularLabel()  // UILabel для verdict
    private let movieImageView = UIImageView.createPosterImageView()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = createContentStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        verdictLabel.text = nil  // Сбрасываем текст verdictLabel
        genresStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        yearLabel.text = nil
        movieImageView.image = nil
    }
    
    public func configure(with viewModel: MovieTableViewCellViewModel) {
        nameLabel.text = viewModel.title
        ratingLabel.text = "⭐ \(viewModel.rating)/10 TMDB"
        yearLabel.text = "🗓️ \(viewModel.releaseYear)"
        
        // Если verdict не nil, показываем и устанавливаем текст; если nil — скрываем label
        if let verdict = viewModel.verdict {
            verdictLabel.text = "🧑‍⚖️ \(verdict)/10 Your verdict"
            verdictLabel.isHidden = false
        } else {
            verdictLabel.isHidden = true
        }
        
        for genre in viewModel.genreNames {
            let genreLabel = UILabel.createGenreLabel(for: genre)
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
                break
            }
        }
    }
    
    func createContentStackView() -> UIStackView {
        let contentStackView = UIStackView(arrangedSubviews: [nameLabel, ratingLabel, verdictLabel, yearLabel, genresStackView])  // Убрали ratingStackView и calendarStackView
        contentStackView.axis = .vertical
        contentStackView.spacing = Spacing.medium
        contentStackView.alignment = .leading
        
        return contentStackView
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

// MARK: - Extensions for UI Components

private extension UILabel {
    static func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TextStyle.heading1
        label.numberOfLines = 2
        return label
    }
    
    static func createRegularLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TextStyle.body
        label.textColor = .label
        return label
    }
    
    static func createLightLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TextStyle.light
        label.textColor = .label
        return label
    }
    
    static func createGenreLabel(for genreName: String) -> UILabel {
        let label = UILabel()
        label.text = genreName
        label.font = TextStyle.light
        label.textColor = .systemBackground
        label.backgroundColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: label.intrinsicContentSize.width + Spacing.medium).isActive = true
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingMiddle
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }
}

private extension UIImageView {
    static func createPosterImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }
}

private extension UIStackView {
    static func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        return stackView
    }
}
