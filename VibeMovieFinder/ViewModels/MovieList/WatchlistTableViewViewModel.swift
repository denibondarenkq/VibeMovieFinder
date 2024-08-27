import Foundation

class WatchlistTableViewViewModel: MoviesTableViewViewModel {
    override init() {
        super.init()
        
        guard let sessionID = AuthManager.shared.sessionId else {
            self.delegate?.didFailToFetchMovies(with: NetworkService.NetworkServiceError.invalidSession)
            return
        }
        
        configure(endpoint: .accountWatchlistMovies(sessionID: sessionID), initialParameters: ["sort_by": "created_at.desc"])
    }
    
    func updateSortOrder(to sortOrder: String) {
        updateRequestParameters(["sort_by": sortOrder])
    }
}
