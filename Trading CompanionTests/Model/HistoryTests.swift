//
//  HistoryTests.swift
//  Trading CompanionTests
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class HistoryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func get(FileName:String,FileExtension:String) -> URL! {
        return Bundle(for: type(of: self)).url(forResource: FileName, withExtension: FileExtension)
    }
    
    func testInitFormAlphavantage() throws {
        
        let data        = try Data(contentsOf: self.get(FileName: "ibm_history", FileExtension: "json"))
        let histories   = try History.from(AlphavantageData: data)
        
        XCTAssertNotNil(histories.first?.date)
        print(histories)
    }

}
