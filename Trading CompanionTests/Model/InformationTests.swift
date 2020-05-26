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
    
    var information : Information!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.information = Information(context: AppDelegate.viewContext)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.information = nil
    }

    func testInit() throws {
    
        XCTAssertNotNil(self.information)
        print(self.information.description)
        
    }
    
    func testSetAlphavantage() throws {
        
        let data = dataRessourse(fileName: "accor_information", fileExtension: "json")
        let reponse = try Information.Reponse.init(from: data)

        information.set(fromAlphavantage: reponse)
        
        XCTAssertNotNil(information.symbol)
        XCTAssertNotNil(information.name)
        XCTAssertNotNil(information.region)
        XCTAssertNotNil(information.currency)
    }
}

extension XCTestCase {
    
    func dataRessourse(fileName:String,fileExtension:String) -> Data {
        let url = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: fileExtension)!
        return try! Data(contentsOf: url)
    }
    
}
