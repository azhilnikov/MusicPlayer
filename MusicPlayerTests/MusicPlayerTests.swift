//
//  MusicPlayerTests.swift
//  MusicPlayerTests
//
//  Created by Alexey on 8/7/17.
//  Copyright © 2017 Alexey Zhilnikov. All rights reserved.
//

import XCTest
@testable import MusicPlayer

class MusicPlayerTests: XCTestCase {
    
    var dataProvider: MusicPlayerDataProvider!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataProvider = MusicPlayerDataProvider()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchData() {
        let iTunesExpectation = expectation(description: "iTunesData")
        
        dataProvider.fetch("jack johnson") { (result) in
            switch result {
            case .success:
                break
                
            case .failure(_):
                XCTFail()
            }
            iTunesExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
    }
}
