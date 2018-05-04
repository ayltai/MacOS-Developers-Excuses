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

extension String {
    var lines: [String] {
        var lines: [String] = []
        
        self.enumerateLines { line, _ in
            lines.append(line)
        }
        
        return lines
    }
}

extension DEPhoto {
    func download() -> Observable<Data> {
        return Observable.create { observer in
            if let urls  : DEPhotoUrls = self.urls,
               let custom: String      = urls.custom,
               let url   : URL         = URL(string: custom) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error: Error = error {
                        observer.onError(error as NSError)
                    } else if let response: HTTPURLResponse = response as? HTTPURLResponse,
                              let data    : Data            = data {
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
