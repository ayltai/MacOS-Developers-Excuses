import Unbox

struct PhotoUrls: Unboxable {
    let custom: String?

    init(unboxer: Unboxer) throws {
        self.custom = unboxer.unbox(key: "custom")
    }
}
