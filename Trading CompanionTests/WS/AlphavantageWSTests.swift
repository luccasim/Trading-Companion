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

    var mock: AlphaMock!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.ws = AlphavantageWS()
        self.mock = AlphaMock(self.symbol)
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.ws = nil
        self.mock = nil
    }
    
    private func callEndpoint(Mock:AlphaMock, Endpoint:[AlphavantageWS.Endpoint]) {
        
        let exp = expectation(description: "TestDetails")
        
        self.ws.update(Endpoints: Endpoint, EquitiesList: [Mock]) { (result) in
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
    
    let symbol = "EUCAR.PA"
    
    // Request
    
    func testHistoryRequest() throws {
        let request = self.ws.historyRequest(Label: symbol)
        print(request.url!)
    }
    
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
    
    func testHistory() throws {
        
        self.callEndpoint(Mock: mock, Endpoint: [.history])
        
        XCTAssertNotNil(mock.history)
        
        print(mock.detail!)
    }
    
    func testDetail() throws {
        
        self.callEndpoint(Mock: mock, Endpoint: [.detail])
        
        XCTAssertNotNil(mock.detail)
        
        print(mock.detail!)
    }
    
    func testLastChange() throws {
        
        self.callEndpoint(Mock: self.mock, Endpoint: [.global])
        
        XCTAssertNotNil(self.mock.global)
        
        print(self.mock.global!)
    }
    
    func testRSI() throws {
        
    }
    
    func testRSIPreview() throws {
        print(AlphavantageWS.RSIReponse.preview)
    }

}
