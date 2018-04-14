import Unbox

struct DEUser: Unboxable {
    let name : String?
    let links: DEUserLinks?
    
    init(unboxer: Unboxer) throws {
        self.name  = unboxer.unbox(key: "name")
        self.links = unboxer.unbox(key: "links")
    }
}
