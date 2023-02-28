import RxSwift

final class UnsplashClient {
    private static let endPoint = "https://nlm693b1gb.execute-api.ap-southeast-1.amazonaws.com/"

    func random(query: [String]?) -> Observable<Photo> {
        return Observable.create { observer in
            var queryItems: [URLQueryItem]?

            if let query = query {
                queryItems = [
                    URLQueryItem(name: "query", value: query[query.count.random()]),
                    URLQueryItem(name: "content_filter", value: "high"),
                    URLQueryItem(name: "client_id", value: "changeme!"),
                ]
            }

            var mutable = URLComponents(url: URL(string: UnsplashClient.endPoint)!, resolvingAgainstBaseURL: true)!
            mutable.path       = "/api/photos/random"
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
