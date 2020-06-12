//
//  ChangeTests.swift
//  Trading CompanionTests
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class ChangeTests: XCTestCase {
    
    var change : Change!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.change = Change(context: AppDelegate.viewContext)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.change = nil
    }
    
    func testInit() throws {
        
        print(self.change.description)
        XCTAssertNotNil(self.change)
        
    }
    
    func testSetFromAlphavantage() throws {
        
        let reponse = AlphavantageWS.GlobalReponse.preview
        
        self.change.set(fromAlphavantage: reponse)
        
        XCTAssertNotNil(change.change)
        XCTAssertNotNil(change.lastDay)
        XCTAssertNotNil(change.percent)
        XCTAssertNotNil(change.previousClose)
        XCTAssertNotNil(change.low)
        XCTAssertNotNil(change.high)
        XCTAssertNotNil(change.price)
        XCTAssertNotNil(change.volume)
        XCTAssertNotNil(change.day)
        
        print(self.change.description)
    }
    
    func testShouldUpdate() {
        
        self.change.update = nil
        XCTAssert(self.change.shouldUpdate)
        
        self.change.update = "2000-01-01 01:01:01"
        XCTAssert(self.change.shouldUpdate)
        
        self.change.update = "2050-01-12 10:10:10"
        XCTAssert(!self.change.shouldUpdate)
        
    }
}
