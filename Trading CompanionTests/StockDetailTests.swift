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
    
    var source : URL {
        return Bundle(for: type(of: self)).url(forResource: "details_query", withExtension: "txt")!
    }
    
    var source2 : URL {
        return Bundle(for: type(of: self)).url(forResource: "accor", withExtension: "txt")!
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    func testSourceFile() throws {
        XCTAssertNotNil(self.source)
    }

    func testInit() throws {
                
        let data = try Data(contentsOf: self.source)
        
        XCTAssertNoThrow(try StockDetail(Symbol: "AMD", Data: data))
        
        XCTAssertThrowsError(try StockDetail(Symbol: "MU", Data: data))
        
        XCTAssertThrowsError(try StockDetail(Symbol: "MSFT", Data: data))
    }

    func testInit2() throws {
        
        let data = try Data(contentsOf: self.source2)
        
        XCTAssertNoThrow(try StockDetail(Symbol: "AC.PAR", Data: data))
    }
}
