//
//  HistoryTests.swift
//  Trading CompanionTests
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

//private var localdata = load

class HistoryTests: XCTestCase {
    
    var history : History!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.history = History(context: AppDelegate.viewContext)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.history = nil
    }
    
    func testInit() {
        
        XCTAssertNotNil(self.history)
        
        print(self.history.description)
    }
    
    func testInitFormAlphavantage() throws {
        
//        let data        = self.dataRessourse(fileName: "ibm_history", fileExtension: "json")
        
//        self.history.set(fromAlphavantage: data)
        
        XCTAssertNotNil(self.history.date)
        XCTAssertNotNil(self.history.open)
        XCTAssertNotNil(self.history.close)
        XCTAssertNotNil(self.history.high)
        XCTAssertNotNil(self.history.low)
        XCTAssertNotNil(self.history.volume)
        
        print(self.history.description)
        
    }

}
