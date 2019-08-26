struct Photo: Codable {
    enum CodingKeys: CodingKey {
        case user
        case urls
    }

    let user: User?
    let urls: PhotoUrls?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.user = try container.decodeIfPresent(User.self, forKey: .user)
        self.urls = try container.decodeIfPresent(PhotoUrls.self, forKey: .urls)
    }
}
