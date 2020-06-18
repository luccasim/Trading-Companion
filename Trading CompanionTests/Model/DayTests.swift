//
//  DayTests.swift
//  Trading CompanionTests
//
//  Created by owee on 10/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class DayTests: XCTestCase {
    
    var model : Day!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.model = Day(context: AppDelegate.viewContext)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        AppDelegate.viewContext.delete(self.model)
        self.model = nil
    }

    func testSetHistoryReponse() throws {
        
        let data = Helper.loadData(FileName: "history.json")
        let wrapper = try AlphavantageWS.HistoryReponse.init(from: data)
        let reponse = wrapper.days[0]
        
        self.model.set(HistoryDay: reponse)
        
        XCTAssertNotNil(self.model.date)
        XCTAssertNotNil(self.model.close)
        XCTAssertNotNil(self.model.open)
        XCTAssertNotNil(self.model.low)
        XCTAssertNotNil(self.model.high)
        XCTAssertNotNil(self.model.volume)
        
        print(self.model.description)
        
    }
    
    func testCandle() throws {
        
        try self.testSetHistoryReponse()
        
        let candle = Day.Candle(Day: self.model)
        
        print(candle.color)
    }

}
