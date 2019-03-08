//
//  UnsplashClientTest.swift
//  DevexcusesTest
//
//  Created by Brian Chung on 8/3/2019.
//  Copyright © 2019 Alan Tai. All rights reserved.
//

import XCTest
import Nimble

class UnsplashClientTest: XCTestCase {

    private var unsplashClient: UnsplashClient!
    private let apiKey = "Please replace your key here"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       unsplashClient = UnsplashClient(apiKey: apiKey)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRandom() {
        let targetSize = CGSize(width: 800, height: 600)
        for _ in 0...2 {
            waitUntil(timeout: 10.0) { done in
                _ = self.unsplashClient.random(size: targetSize, query: nil)
                    .subscribe(onNext: { (photo) in
                        done()
                    })
            }
        }
    }
}
