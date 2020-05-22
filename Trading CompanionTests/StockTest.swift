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
    
    func getSource(FileName:String, Extension:String) -> URL {
        return Bundle(for: type(of: self)).url(forResource: FileName, withExtension: Extension)!
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit() throws {
        
        let data = try Data(contentsOf: self.getSource(FileName: "stocks", Extension: "json"))
        
        let decoder = JSONDecoder()
        
        let stocks = try decoder.decode([Stock].self, from: data)
        
        print(stocks)
    }
    
    
}
