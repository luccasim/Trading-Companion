//
//  StockHistoryTests.swift
//  Trading CompanionTests
//
//  Created by owee on 18/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class StockHistoryTests: XCTestCase {

    func getSource(FileName:String,Extension:String) -> URL {
        return Bundle(for: type(of: self)).url(forResource: FileName, withExtension: Extension)!
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitMeta() throws {
        
        let data = try Data(contentsOf: self.getSource(FileName: "meta_history", Extension: "json"))
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        
        XCTAssertNoThrow(try StockHistory.Meta(FromJson: json))
    }
    
    func testInitDay() throws {
        
        let data = try Data(contentsOf: self.getSource(FileName: "day_history", Extension: "json"))
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        
        XCTAssertNoThrow(try StockHistory.Day(FromJson: json))
    }
    
    func testInit() throws {
        
        let data  = try Data(contentsOf: self.getSource(FileName: "IBM_history", Extension: "json"))
        
        XCTAssertNoThrow(try StockHistory(fromAlphavantage:data))
    }

}
