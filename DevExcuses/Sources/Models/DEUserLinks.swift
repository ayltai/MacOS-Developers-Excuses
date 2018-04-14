import Unbox

struct DEUserLinks: Unboxable {
    let html: String?
    
    init(unboxer: Unboxer) throws {
        self.html = unboxer.unbox(key: "html")
    }
}
