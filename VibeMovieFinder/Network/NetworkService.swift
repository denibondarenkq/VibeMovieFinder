import Foundation

final class NetworkService {
    static let shared = NetworkService()
    //    private let cacheManager = APICacheManager()
    
    private init() {}
    
    enum NetworkServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
        case unexpectedResponse(URLResponse?)
        case apiError(String)
        case failedResponse(HTTPURLResponse?)
        case invalidSession
    }
    
    func execute<T: Decodable>(endpoint: Endpoint, parameters: [String: Any] = [:], expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = try? endpoint.makeRequest(parameters: parameters) else {
            completion(.failure(NetworkServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NetworkServiceError.failedToGetData))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                completion(.failure(NetworkServiceError.invalidSession))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                
                if let result = apiResponse.data {
                    completion(.success(result))
                } else {
                    let errorMessage = apiResponse.statusMessage ?? "Unknown error"
                    let error = NSError(domain: "", code: apiResponse.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
