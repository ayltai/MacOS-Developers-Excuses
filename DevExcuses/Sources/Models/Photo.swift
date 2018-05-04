import Unbox

struct Photo: Unboxable {
    let user: User?
    let urls: PhotoUrls?

    init(unboxer: Unboxer) throws {
        self.user = unboxer.unbox(key: "user")
        self.urls = unboxer.unbox(key: "urls")
    }
}
