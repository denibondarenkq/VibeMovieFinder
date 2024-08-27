import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {
        loadBearerToken()
        loadAuthData()
    }
    
    private(set) var bearerToken: String?
    
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
    
    private func loadBearerToken() {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let xml = FileManager.default.contents(atPath: path),
           let plist = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainers, format: nil) as? [String: Any],
           let token = plist["TMDBBearerToken"] as? String {
            self.bearerToken = token
        } else {
            print("Bearer token not found in Secrets.plist")
        }
    }
    
    private func loadAuthData() {
        self.requestToken = UserDefaults.standard.string(forKey: "requestToken")
        self.sessionId = UserDefaults.standard.string(forKey: "sessionId")
    }
    
    func createRequestToken(completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = Endpoint.requestToken
        NetworkService.shared.execute(endpoint: endpoint, expecting: RequestTokenResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.requestToken = response.requestToken
                completion(.success(response.requestToken))
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
        NetworkService.shared.execute(endpoint: endpoint, expecting: SessionIDResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                if response.success {
                    guard let sessionId = response.sessionID else {
                        completion(.failure(NetworkService.NetworkServiceError.failedToGetData))
                        return
                    }
                    self?.sessionId = sessionId
                    completion(.success(sessionId))
                } else {
                    let errorMessage = response.statusMessage ?? "Unknown error"
                    let error = NSError(domain: "", code: response.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
