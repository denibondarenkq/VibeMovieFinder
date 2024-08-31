import Foundation

final class APIKeyManager {
    static let shared = APIKeyManager()
    
    private(set) var geminiAPIKey: String?
    private(set) var bearerToken: String?
    
    private init() {
        loadGeminiAPIKey()
        loadBearerToken()
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
    
    private func loadGeminiAPIKey() {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let xml = FileManager.default.contents(atPath: path),
           let plist = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainers, format: nil) as? [String: Any],
           let apiKey = plist["GeminiAPIKey"] as? String {
            self.geminiAPIKey = apiKey
        } else {
            print("Gemini API key not found in Secrets.plist")
        }
    }
}
