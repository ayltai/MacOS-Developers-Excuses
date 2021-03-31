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

extension Photo {
    func download(size: CGSize) -> Observable<Data> {
        return Observable.create { observer in
            if
                let urls = self.urls,
                let raw  = urls.raw,
                let url  = URL(string: raw + "&auto=compress&fit=crop&w=" + String(Int(size.width)) + "&h=" + String(Int(size.height))) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        observer.onError(error as NSError)
                    } else if
                        let response = response as? HTTPURLResponse,
                        let data     = data {
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
