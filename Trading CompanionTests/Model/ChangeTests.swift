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

    private func get(FileName:String,FileExtension:String) -> URL! {
        return Bundle(for: type(of: self)).url(forResource: FileName, withExtension: FileExtension)
    }
    
    func testInit() throws {
        
        XCTAssertNotNil(self.change)
        
        print(self.change.description)
    }
    
    func testSetFromAlphavantage() throws {
        
        let data    = try Data(contentsOf: self.get(FileName: "ibm_change", FileExtension: "json"))
        
        self.change.set(fromAlphavantage: data)
        
        XCTAssertNotNil(change.change)
        XCTAssertNotNil(change.lastDay)
        XCTAssertNotNil(change.percent)
        XCTAssertNotNil(change.previousClose)
        XCTAssertNotNil(change.low)
        XCTAssertNotNil(change.high)
        XCTAssertNotNil(change.price)
        XCTAssertNotNil(change.volume)
        
        print(self.change.description)
    }
}
