import AppKit
import RxSwift

extension HTTPURLResponse {
    var isSuccess: Bool {
        return self.statusCode == 200
    }
    
    var statusMessage: String {
        return HTTPURLResponse.localizedString(forStatusCode: self.statusCode)
    }
}

extension NSFont {
    var lineHeight: Float {
        return ceilf(Float(self.ascender + abs(self.descender) + self.leading))
    }
}

extension NSImage {
    func draw(at: NSPoint) {
        self.draw(
            at       : at,
            from     : NSZeroRect,
            operation: .sourceOver,
            fraction : DEConfigs.Image.alpha
        )
    }
}

extension NSString {
    func draw(font: NSFont, drawIn: NSRect, style: NSParagraphStyle, shadow: NSShadow) {
        self.draw(
            in            : drawIn,
            withAttributes: [
                NSAttributedStringKey.foregroundColor: NSColor.white,
                NSAttributedStringKey.font           : font,
                NSAttributedStringKey.paragraphStyle : style,
                NSAttributedStringKey.shadow         : shadow
            ]
        )
    }
}

extension Int {
    func random() -> Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

extension Double {
    public static func random(min: Double, max: Double) -> Double {
        return Double(arc4random()) / 0xffffffff * (max - min) + min
    }
}

extension DEPhoto {
    func download() -> Observable<Data> {
        return Observable.create { observer in
            if let urls = self.urls, let custom = urls.custom, let url = URL(string: custom) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        observer.onError(error as NSError)
                    } else if let response = response as? HTTPURLResponse, let data = data {
                        if response.isSuccess {
                            observer.onNext(data)
                        } else {
                            observer.onError(NSError(domain: response.statusMessage, code: response.statusCode))
                        }
                    } else {
                        observer.onError(NSError(domain: "Response is empty", code: 0))
                    }
                }.resume()
            }
            
            return Disposables.create()
        }
    }
}
