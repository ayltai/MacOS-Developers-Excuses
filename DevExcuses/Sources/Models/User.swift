struct User: Codable {
    enum CodingKeys: CodingKey {
        case name
        case links
    }

    let name : String?
    let links: UserLinks?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name  = try container.decodeIfPresent(String.self, forKey: .name)
        self.links = try container.decodeIfPresent(UserLinks.self, forKey: .links)
    }
}
