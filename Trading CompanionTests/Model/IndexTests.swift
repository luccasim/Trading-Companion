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
    
    var model : Index!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.model = Index(context: AppDelegate.viewContext)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.model = nil
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
        self.model.marketIsClose ? print("You could update") : print("Market is open, try after 17:30:00")
    }
    
    func testMandatoryDate() throws {
        print("Mandatory:\n\(Index.mandatoryUpdate)")
    }

}
