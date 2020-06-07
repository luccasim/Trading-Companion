//
//  AlphavantageWSTests.swift
//  Trading CompanionTests
//
//  Created by owee on 20/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

fileprivate let rsiData = load(FileName: "rsi.json")

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
        var rsi     : AlphavantageWS.RSIReponse?
        
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
        
        func setRSI(Reponse: AlphavantageWS.RSIReponse) {
            self.rsi = Reponse
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
    
    private func show(Request:URLRequest) {
        
        let exp = expectation(description: "w8")
        
        print("Request \(Request.url!)")
        
        URLSession.shared.dataTask(with: Request) { (data, rep, error) in
            if let data = data {
                if let str = String(data: data, encoding: .utf8) {
                    print(str)
                }
            }
            exp.fulfill()
        }.resume()
        
        waitForExpectations(timeout: 30) { error in}
    }
    
    let symbol = "AF.PA"
    
    // Request
    
    func testDetailsRequest() throws {
        let request = self.ws.detailsRequest(Symbol: symbol)
        print(request.url!)
    }
    
    func testChangeRequest() throws {
        let request = self.ws.globalRequest(Label: symbol)
        print(request.url!)
    }
    
    func testRSIRequest() throws {
        let request = self.ws.rsiRequest(Label: symbol)
        
        self.show(Request: request)
    }
    
    // Endpoint Call
    
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
    
    func testRSI() throws {
        
    }
    
    // Parsing

    func testRSIReponse() throws {
        
        let data = rsiData
        let reponse = try AlphavantageWS.RSIReponse(fromDataReponse: data)
        
        print(reponse.result)
    }
    
    func testRSIPreview() throws {
        print(AlphavantageWS.RSIReponse.preview)
    }

}
