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
        var history : AlphavantageWS.HistoryReponse?
        
        init(_ str:String) {
            self.label = str
        }
        
        func setDetail(Reponse: AlphavantageWS.InformationReponse) {
            self.detail = Reponse
        }
        
        func setGlobal(Reponse: AlphavantageWS.GlobalReponse) {
            self.global = Reponse
        }
        
        func setHistory(Reponse: AlphavantageWS.HistoryReponse) {
            self.history = Reponse
        }
    }
    
    private func callEndpoint(Mock:Mock, Endpoint:AlphavantageWS.Endpoint) {
        
        let exp = expectation(description: "TestDetails")
        
        self.ws.update(Endpoint: .detail, EquitiesList: [Mock]) { (result) in
            switch result {
            case .success(_): break
            case .failure(_): exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 60) { (error) in
            
        }
    }
    
    let symbol = "GTT.PA"
    
    func testDetail() throws {
        
        let mock = Mock(self.symbol)
        mock.label = symbol
        
        self.callEndpoint(Mock: mock, Endpoint: .detail)
        
        XCTAssertNotNil(mock.detail)
        
        print(mock.detail!)
        
    }

}
