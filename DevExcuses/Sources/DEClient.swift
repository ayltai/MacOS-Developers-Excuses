import RxSwift
import Unbox

final class DEClient {
    private struct Constants {
        static let endPoint: String = "https://api.unsplash.com/"
    }
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func random(size: CGSize, query: [String]?) -> Observable<DEPhoto> {
        return Observable.create { observer in
            var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "client_id", value: self.apiKey),
                URLQueryItem(name: "w", value: String(Int(size.width))),
                URLQueryItem(name: "h", value: String(Int(size.height)))
            ]
            
            if let query: [String] = query {
                queryItems.append(URLQueryItem(name: "query", value: query[query.count.random()]))
            }
            
            var mutable: URLComponents = URLComponents(url: URL(string: DEClient.Constants.endPoint)!, resolvingAgainstBaseURL: true)!
            mutable.path       = "/photos/random"
            mutable.queryItems = queryItems
            
            URLSession.shared.dataTask(with: mutable.url!) { (data, response, error) in
                if let error: Error = error {
                    observer.onError(error as NSError)
                } else if let response: HTTPURLResponse = response as? HTTPURLResponse,
                          let data    : Data            = data {
                    if response.isSuccess {
                        do {
                            let photo: DEPhoto = try unbox(data: data)
                            observer.onNext(photo)
                        } catch let error as NSError {
                            observer.onError(error)
                        }
                    } else {
                        observer.onError(NSError(domain: response.statusMessage, code: response.statusCode))
                    }
                } else {
                    observer.onError(NSError(domain: "Response is empty", code: 0))
                }
            }.resume()
            
            return Disposables.create()
        }
    }
}
