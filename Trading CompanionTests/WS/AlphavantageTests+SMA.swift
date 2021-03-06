//
//  AlphavantageTests+mm.swift
//  Trading CompanionTests
//
//  Created by owee on 15/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class AlphavantageTests_SMA: XCTestCase {
    
    var ws : AlphavantageWS = AlphavantageWS()
    var model : AlphaMock!
    var symbol = "AF.PA"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        self.model = AlphaMock(symbol)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.model = nil
    }

    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testEndpoint() throws {
        
        let exp = expectation(description: "SMA Endpoint")
        var error : Error? = nil
        
        self.ws.update(Endpoints: [.mm], EquitiesList: [self.model]) { (result) in
            switch result {
            case .success(let model): print("Success = \(model)")
            case .failure(let err): error = err
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (err) in
            error = err
        }
        
        if let error = error {
            print(error.localizedDescription)
            throw error
        }
        
        XCTAssertNotNil(self.model.sma)
        
        print(self.model!.sma!)
    }
    
    func testRequest() throws {
        
        let request = AlphavantageWS().mmRequest(model: self.model)
        
        XCTAssertNotNil(request.url)
        
        print(request.url!)
    }
    
    func testLocal() throws {
        
        let data = Helper.loadData(FileName: "mm.json")
        let reponse = try AlphavantageWS.SMAReponse.init(withData: data)
        
        print(reponse)
    }

}
