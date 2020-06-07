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
        self.model = Equity.preview
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.model = nil
    }

    func testResetData() throws {
        
        let equities = Equity.resetEquities
        
        print(equities)
    }
    
    func testTitleFormat() throws {
        
        let equity = Equity.preview
        
        print(equity.name)
    }
    
    func testShouldUpdateChange() throws {
        print(self.model.change)
    }
    
    func testSetRsi() throws {
        
        let data = Helper.loadData(FileName: "rsi.json")
        let reponse = try AlphavantageWS.RSIReponse.init(fromDataReponse: data)
        
        self.model.setRSI(Reponse: reponse)
        XCTAssertNotNil(self.model.rsi)
        
        self.model.rsi?.forEach({print($0)})
        
    }
    
    func testLastRSI() {
        
        self.model.setRSI(Reponse: AlphavantageWS.RSIReponse.preview)
        let str = self.model.lastRSI
        
        XCTAssert(str.isEmpty == false)
        print(str)
    }
}
