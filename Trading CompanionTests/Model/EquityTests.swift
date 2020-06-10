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
        self.model = Equity(context: Helper.testmoc)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        AppDelegate.viewContext.delete(self.model)
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
//        print(self.model.change)
    }
    
    func testShouldInit() {
        
    }
    
    func testSetHistory() throws {
        
        let data = Helper.loadData(FileName: "history.json")
        let wrapper = try AlphavantageWS.HistoryReponse(from: data)
        
        self.model.setHistory(Reponse: wrapper)

        let days = (self.model.days?.allObjects as? [Day]) ?? []
        
        XCTAssert(days.count > 0)
        
        print(days)
    }
    
    func testSetRsi() throws {
        
        let data = Helper.loadData(FileName: "rsi.json")
        let reponse = try AlphavantageWS.RSIReponse.init(fromDataReponse: data)
        
    }
    
    func testLastRSI() {
        
        self.model.setRSI(Reponse: AlphavantageWS.RSIReponse.preview)
        let str = self.model.lastRSI
        
        XCTAssert(str.isEmpty == false)
        print(str)
    }
}
