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

    var mock: Mock!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.ws = AlphavantageWS()
        self.mock = Mock(self.symbol)
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.ws = nil
        self.mock = nil
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
        
        self.ws.update(Endpoint: Endpoint, EquitiesList: [Mock]) { (result) in
            switch result {
            case .success(_): break
            case .failure(let error): print(error.localizedDescription)
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 60) { (error) in
            
        }
    }
    
    let symbol = "AF.PA"
    
    func testDetailsRequest() throws {
        let request = self.ws.detailsRequest(Symbol: symbol)
        print(request.url!)
    }
    
    func testChangeRequest() throws {
        let request = self.ws.globalRequest(Label: symbol)
        print(request.url!)
    }
    
    func testDetail() throws {
        
        self.callEndpoint(Mock: mock, Endpoint: .detail)
        
        XCTAssertNotNil(mock.detail)
        
        print(mock.detail!)
        
    }
    
    func testLastChange() throws {
        
        self.callEndpoint(Mock: self.mock, Endpoint: .global)
        
        XCTAssertNotNil(self.mock.global)
        
        print(self.mock.global!)
    }

}
