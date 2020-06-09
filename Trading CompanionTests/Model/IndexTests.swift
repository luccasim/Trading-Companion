//
//  IndexTests.swift
//  Trading CompanionTests
//
//  Created by owee on 25/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class IndexTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResetValue() throws {
                
        let index = Index.main
        
        print(index)
    }
    
    func testStoredValue() throws {
        
        try self.testResetValue()
        
        let index = Index.main
        
        AppDelegate.viewContext.delete(index)
        try AppDelegate.viewContext.save()
    }
    
    func testMarketClose() throws {
        if Index.marketIsOpen {
            print("You could update")
        }
        else {
            print("Market is open, try after 17:30:00")
        }
    }

}
