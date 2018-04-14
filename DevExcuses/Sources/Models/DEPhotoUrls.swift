import Unbox

struct DEPhotoUrls: Unboxable {
    let custom: String?
    
    init(unboxer: Unboxer) throws {
        self.custom = unboxer.unbox(key: "custom")
    }
}
