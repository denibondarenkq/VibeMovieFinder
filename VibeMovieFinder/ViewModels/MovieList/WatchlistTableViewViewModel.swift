import Foundation

class WatchlistTableViewViewModel: MoviesTableViewViewModel {
    override init() {
        super.init()
        
        guard let sessionID = AuthManager.shared.sessionId else {
            // Обработайте ситуацию, когда sessionID равно nil
            // Например, можете выбросить исключение или перенаправить пользователя на экран авторизации
            print("Session ID is nil, redirecting to login.")
            return
        }
        
        configure(endpoint: .accountWatchlistMovies(sessionID: sessionID), initialParameters: ["sort_by": "created_at.desc"])
    }
    
    func updateSortOrder(to sortOrder: String) {
        updateRequestParameters(["sort_by": sortOrder])
    }
}
