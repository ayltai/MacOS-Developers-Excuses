import Unbox

struct UserLinks: Unboxable {
    let html: String?

    init(unboxer: Unboxer) throws {
        self.html = unboxer.unbox(key: "html")
    }
}
