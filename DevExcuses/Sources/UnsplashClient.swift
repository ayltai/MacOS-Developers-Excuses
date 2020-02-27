import RxSwift

final class UnsplashClient {
    private static let endPoint = "https://unsplash-api-proxy.appspot.com/"

    func random(size: CGSize, query: [String]?) -> Observable<Photo> {
        return Observable.create { observer in
            var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "w", value: String(Int(size.width))),
                URLQueryItem(name: "h", value: String(Int(size.height)))
            ]

            if let query = query {
                queryItems.append(URLQueryItem(name: "query", value: query[query.count.random()]))
            }

            var mutable = URLComponents(url: URL(string: UnsplashClient.endPoint)!, resolvingAgainstBaseURL: true)!
            mutable.path       = "/photos/random"
            mutable.queryItems = queryItems

            URLSession.shared.dataTask(with: mutable.url!) { (data, response, error) in
                if let error = error {
                    observer.onError(error as NSError)
                } else if
                    let response = response as? HTTPURLResponse,
                    let data     = data {
                    if response.isSuccess {
                        do {
                            let photo: Photo = try JSONDecoder().decode(Photo.self, from: data)
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
