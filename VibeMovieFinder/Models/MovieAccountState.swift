struct MovieAccountState: Codable {
    let id: Int
    let favorite: Bool
    let rated: RatedState?
    let watchlist: Bool
}

enum RatedState: Codable {
    case rated(Rated)
    case unrated(Bool)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let rated = try? container.decode(Rated.self) {
            self = .rated(rated)
        } else if let unrated = try? container.decode(Bool.self) {
            self = .unrated(unrated)
        } else {
            throw DecodingError.typeMismatch(RatedState.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unexpected type for RatedState"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .rated(let rated):
            try container.encode(rated)
        case .unrated(let unrated):
            try container.encode(unrated)
        }
    }
}

struct Rated: Codable {
    let value: Int
}
