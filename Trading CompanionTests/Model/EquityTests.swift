//
//  EquityTests.swift
//  Trading CompanionTests
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class EquityTests: XCTestCase {
    
    var model : Equity!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResetData() throws {
        
        let equities = Equity.resetEquities
        
        print(equities)
    }
    
    func testTitleFormat() throws {
        
        let equity = Equity
    }
}
