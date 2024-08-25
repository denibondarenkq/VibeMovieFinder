import Foundation

class WatchlistTableViewViewModel: MoviesTableViewViewModel {
    override init() {
        let accountId = AuthManager.shared.accountId
        super.init()
        configure(endpoint: .accountWatchlistMovies(accountId: accountId), initialParameters: ["sort_by": "created_at.desc"])
    }
    
    func updateSortOrder(to sortOrder: String) {
        updateRequestParameters(["sort_by": sortOrder])
    }
}
