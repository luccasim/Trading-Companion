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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func get(FileName:String,FileExtension:String) -> URL! {
        return Bundle(for: type(of: self)).url(forResource: FileName, withExtension: FileExtension)
    }
    
    func testInitFromAlphavantage() throws {
        
        let data = try Data(contentsOf: self.get(FileName: "ibm_change", FileExtension: "json"))
        
        let change = try Change.with(AlphavantageData: data)
        
        print(change)
    }
}
