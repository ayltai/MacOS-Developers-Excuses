struct PhotoUrls: Codable {
    enum CodingKeys: CodingKey {
        case custom
    }

    let custom: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.custom = try container.decodeIfPresent(String.self, forKey: .custom)
    }
}
