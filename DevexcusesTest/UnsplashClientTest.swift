import XCTest
import Nimble

class UnsplashClientTest: XCTestCase {
    private var unsplashClient: UnsplashClient!

    override func setUp() {
       unsplashClient = UnsplashClient(apiKey: "Please replace your key here")
    }

    func testRandom() {
        let targetSize = CGSize(width: 800, height: 600)

        for _ in 0...2 {
            waitUntil(timeout: 10.0) { done in
                _ = self.unsplashClient.random(size: targetSize, query: nil)
                    .subscribe(onNext: { _ in
                        done()
                    })
            }
        }
    }
}
