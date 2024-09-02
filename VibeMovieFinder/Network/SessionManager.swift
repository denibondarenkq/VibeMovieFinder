import Foundation
final class SessionManager {
    static let shared = SessionManager()

    private init() {
        loadAuthData()
    }

    private(set) var requestToken: String? {
        didSet {
            UserDefaults.standard.set(requestToken, forKey: "requestToken")
        }
    }

    private(set) var sessionId: String? {
        didSet {
            UserDefaults.standard.set(sessionId, forKey: "sessionId")
        }
    }

    private func loadAuthData() {
        self.requestToken = UserDefaults.standard.string(forKey: "requestToken")
        self.sessionId = UserDefaults.standard.string(forKey: "sessionId")
    }
    
    func createRequestToken(completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = Endpoint.requestToken
        NetworkService.shared.execute(endpoint: endpoint, expecting: APIResponse<RequestTokenResponse>.self) { [weak self] result in
            switch result {
            case .success(let response):
                if let token = response.data?.requestToken {
                    self?.requestToken = token
                    completion(.success(token))
                } else {
                    completion(.failure(NetworkService.NetworkServiceError.failedToGetData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func authorizeToken(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let requestToken = requestToken else {
            completion(.failure(NetworkService.NetworkServiceError.failedToCreateRequest))
            return
        }
        let authURL = URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)")!
        completion(.success(authURL))
    }

    func createSessionId(completion: @escaping (Result<String, Error>) -> Void) {
        guard let requestToken = requestToken else {
            completion(.failure(NetworkService.NetworkServiceError.failedToCreateRequest))
            return
        }

        let endpoint = Endpoint.createSessionId(requestToken: requestToken)
        NetworkService.shared.execute(endpoint: endpoint, expecting: APIResponse<SessionIDResponse>.self) { [weak self] result in
            switch result {
            case .success(let response):
                if let sessionId = response.data?.sessionID {
                    self?.sessionId = sessionId
                    completion(.success(sessionId))
                } else {
                    completion(.failure(NetworkService.NetworkServiceError.failedToGetData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteSession(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let sessionId = sessionId else {
            completion(.failure(NetworkService.NetworkServiceError.invalidSession))
            return
        }

        let endpoint = Endpoint.deleteSession(sessionId: sessionId)
        NetworkService.shared.execute(endpoint: endpoint, expecting: APIResponse<Bool>.self) { [weak self] result in
            switch result {
            case .success(let response):
                if response.success == true {
                    self?.clearSession()
                    completion(.success(true))
                } else {
                    completion(.failure(NetworkService.NetworkServiceError.apiError(response.statusMessage ?? "Failed to delete session")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func clearSession() {
        sessionId = nil
        requestToken = nil
        UserDefaults.standard.removeObject(forKey: "sessionId")
        UserDefaults.standard.removeObject(forKey: "requestToken")
    }
}
