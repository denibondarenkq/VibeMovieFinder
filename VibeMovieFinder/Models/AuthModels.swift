import Foundation

struct RequestTokenResponse: Decodable {
    let success: Bool
    let expiresAt, requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

struct SessionIDResponse: Decodable {
    let success: Bool
    let sessionID: String?
    let statusCode: Int?
    let statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
