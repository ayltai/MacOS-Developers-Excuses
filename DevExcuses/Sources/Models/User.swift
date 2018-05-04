import Unbox

struct User: Unboxable {
    let name : String?
    let links: UserLinks?

    init(unboxer: Unboxer) throws {
        self.name  = unboxer.unbox(key: "name")
        self.links = unboxer.unbox(key: "links")
    }
}
