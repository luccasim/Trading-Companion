//
//  EngineTests.swift
//  Trading CompanionTests
//
//  Created by owee on 18/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class EngineTests: XCTestCase {
    
    var model : Engine!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.model = Engine()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.model = nil
    }

    

}
