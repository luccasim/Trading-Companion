//
//  InformationTests.swift
//  Trading CompanionTests
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class InformationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func getSource(fileName:String,fileExtension:String) -> URL {
        return Bundle(for: type(of: self)).url(forResource: fileName, withExtension: fileExtension)!
    }

    func testInit() throws {
        
        let data = try Data(contentsOf: self.getSource(fileName: "accor_information", fileExtension: "json"))
        
        let information = try Information.with(AlphavantageData: data)
        
        XCTAssertNotNil(information.reponse)
        
        if let reponse = information.reponse {
            print(reponse)
        }
    }
}
