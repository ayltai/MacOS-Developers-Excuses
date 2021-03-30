struct PhotoUrls: Codable {
    enum CodingKeys: CodingKey {
        case raw
    }

    let raw: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.raw = try container.decodeIfPresent(String.self, forKey: .raw)
    }
}
