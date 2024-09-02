struct APIResponse<T: Decodable>: Decodable {
    let success: Bool?
    let statusCode: Int?
    let statusMessage: String?
    let data: T?

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decodeIfPresent(Bool.self, forKey: .success)
        statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode)
        statusMessage = try container.decodeIfPresent(String.self, forKey: .statusMessage)
        
//        data = try? T(from: decoder)
        if let data = try? container.decodeIfPresent(T.self, forKey: .data) {
            self.data = data
        } else {
            // Если нет, попробуем декодировать корневой объект как T
            self.data = try? T(from: decoder)
        }
    }
}
