import Unbox

struct DEPhoto: Unboxable {
    let user: DEUser?
    let urls: DEPhotoUrls?
    
    init(unboxer: Unboxer) throws {
        self.user = unboxer.unbox(key: "user")
        self.urls = unboxer.unbox(key: "urls")
    }
}
