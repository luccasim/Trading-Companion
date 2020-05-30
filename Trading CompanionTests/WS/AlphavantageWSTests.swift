//
//  AlphavantageWSTests.swift
//  Trading CompanionTests
//
//  Created by owee on 20/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class AlphavantageWSTests: XCTestCase {
    
    var ws : AlphavantageWS!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.ws = AlphavantageWS()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.ws = nil
    }
    
    class Mock : AlphavantageWSModel {
        
        var label   : String
        var detail  : AlphavantageWS.InformationReponse?
        var global  : AlphavantageWS.GlobalReponse?
        
        init(_ str:String) {
            self.label = str
        }
        
        func setDetail(Data: Data) {
            self.detail = try? AlphavantageWS.InformationReponse.init(from: Data)
        }
        
        func setGlobal(Data: Data) {
            self.global = try? AlphavantageWS.GlobalReponse.init(from: Data)
        }
    }
    
    let symbol = "GTT.PA"
    
    func testDetail() throws {
        
        let mock = Mock(self.symbol)
        mock.label = symbol
        
        let exp = expectation(description: "TestDetails")
        
        self.ws.update(Endpoint: .detail, EquitiesList: [mock]) { (result) in
            switch result {
            case .success(_): break
            case .failure(_): exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 60) { (error) in
            
        }
        
        XCTAssertNotNil(mock.detail)
        
        print(mock.detail!)
        
    }

}
