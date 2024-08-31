import GoogleGenerativeAI
import Foundation

class GeminiService {
    static let shared = GeminiService()
    
    let model: GenerativeModel
    
    private init() {
        guard let apiKey = APIKeyManager.shared.geminiAPIKey else {
            fatalError("API key not found")
        }
        
        model = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: apiKey,
            generationConfig: GenerationConfig(responseMIMEType: "application/json")
        )
    }
    
    func GenerateVibes(prompt: String, completion: @escaping (Result<[Vibe], Error>) -> Void) {
        Task {
            do {
                let response = try await model.generateContent(prompt)
                
                if let text = response.text {
                    guard let jsonData = text.data(using: .utf8) else {
                        completion(.failure(NSError(domain: "GeminiService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON string to Data"])))
                        return
                    }
                    let decoder = JSONDecoder()
                    let vibes = try decoder.decode([Vibe].self, from: jsonData)
                    completion(.success(vibes))
                } else {
                    completion(.failure(NSError(domain: "GeminiService", code: 2, userInfo: [NSLocalizedDescriptionKey: "No text in response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func GenerateMovies(prompt: String, completion: @escaping (Result<[MovieGemini], Error>) -> Void) {
        Task {
            do {
                let response = try await model.generateContent(prompt)
                
                if let text = response.text {
                    guard let jsonData = text.data(using: .utf8) else {
                        completion(.failure(NSError(domain: "GeminiService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON string to Data"])))
                        return
                    }
                    let decoder = JSONDecoder()
                    let movies = try decoder.decode([MovieGemini].self, from: jsonData)
                    completion(.success(movies))
                } else {
                    completion(.failure(NSError(domain: "GeminiService", code: 2, userInfo: [NSLocalizedDescriptionKey: "No text in response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
}
