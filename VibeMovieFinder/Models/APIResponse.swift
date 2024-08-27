struct APIResponse<T: Decodable>: Decodable {
    let success: Bool?
    let statusCode: Int?
    let statusMessage: String?
    let data: T?

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
//        case results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decodeIfPresent(Bool.self, forKey: .success)
        statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode)
        statusMessage = try container.decodeIfPresent(String.self, forKey: .statusMessage)
        
        data = try? T(from: decoder)

//        // Попытка декодировать данные из ключа "results", если не удается, декодируем напрямую
//        if let results = try? container.decode(T.self, forKey: .results) {
//            data = results
//        } else {
//            data = try? T(from: decoder)
//        }
    }
}
