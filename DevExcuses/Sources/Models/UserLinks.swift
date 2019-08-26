struct UserLinks: Codable {
    enum CodingKeys: CodingKey {
        case html
    }

    let html: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.html = try container.decodeIfPresent(String.self, forKey: .html)
    }
}
