import Foundation

protocol AuthViewModelDelegate: AnyObject {
    func didReceiveAuthURL(_ url: URL)
    func didAuthorizeSuccessfully()
    func didFailWithError(_ error: Error)
}

final class AuthViewModel {
    weak var delegate: AuthViewModelDelegate?
    
    func startAuthorization() {
        SessionManager.shared.createRequestToken { [weak self] result in
            switch result {
            case .success:
                self?.authorizeToken()
            case .failure(let error):
                self?.delegate?.didFailWithError(error)
            }
        }
    }
    
    private func authorizeToken() {
        SessionManager.shared.authorizeToken { [weak self] result in
            switch result {
            case .success(let url):
                self?.delegate?.didReceiveAuthURL(url)
            case .failure(let error):
                self?.delegate?.didFailWithError(error)
            }
        }
    }
    
    func createSession() {
        SessionManager.shared.createSessionId { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didAuthorizeSuccessfully()
            case .failure(let error):
                self?.delegate?.didFailWithError(error)
            }
        }
    }
}
