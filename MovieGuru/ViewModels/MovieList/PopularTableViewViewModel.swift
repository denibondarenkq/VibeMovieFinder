import Foundation

class PopularTableViewViewModel: MoviesTableViewViewModel {
    override init() {
        super.init()
        configure(endpoint: .moviePopular, initialParameters: ["page": 1, ])
    }
}
