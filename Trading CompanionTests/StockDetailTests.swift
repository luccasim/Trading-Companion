//
//  StockDetailTests.swift
//  Trading CompanionTests
//
//  Created by owee on 13/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class StockDetailTests: XCTestCase {
    
    var model : StockDetail!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func getSource(Filename:String,Extension:String) -> URL {
        return Bundle(for: type(of: self)).url(forResource: Filename, withExtension: Extension)!
    }

    func testInit() throws {
                
        let data = try Data(contentsOf: getSource(Filename: "accor_detail", Extension: "json"))
        
        XCTAssertNoThrow(try StockDetail(FromData: data))
    }
}
