//
//  StockTest.swift
//  Trading CompanionTests
//
//  Created by owee on 17/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class StockTest: XCTestCase {
    
    var model : StockTest!
    
    var source : URL {
        return Bundle(for: type(of: self)).url(forResource: "history", withExtension: "json")!
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testInit() throws {
    
        let data = try Data(contentsOf: self.source)
        let details = StockDetail(name: "mock", region: "mock")

        XCTAssertNoThrow(try Stock(Symbol:"IBM", DataHistory:data, Details:details))
    }
    
    
}
