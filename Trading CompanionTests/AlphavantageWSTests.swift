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
    
    var ws : AlphavantageService!
    
    let symbol = "FCH"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.ws = AlphavantageService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.ws = nil
    }
    
    func testGlobalRequest() throws {
        
//        let request = self.ws.globalRequest(Symbol: self.symbol)
        let request = self.ws.detailsRequest(Symbol: self.symbol)
        
        guard let url = request.url else {
            return XCTAssertNil(nil)
        }
        
        print(url)
        
        let exp = expectation(description: "Read Data")
        
        URLSession.shared.dataTask(with: request) { (data, rep, error) in
            
            if let data = data {
                
                if let str = String(data: data, encoding: .utf8) {
                    print(str)
                }
            }
            
            exp.fulfill()
            
        }.resume()
        
        waitForExpectations(timeout: 30) { (error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }

    func testGlobalTask() throws {
        
        let wsexpectation = expectation(description: "Global Task")
        var globalResult : StockGlobal?
        
        self.ws.globalTask(Symbol: self.symbol) { (result) in
            
            switch result {
            case .success(let global): globalResult = global
            default: break
            }
            
            wsexpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNotNil(globalResult)
            print(globalResult!)
        }
    }
    
    func testHistoryTask() throws {
        
        let wsexpectation = expectation(description: "History Task")
        var stock : StockHistory?
        
        self.ws.historyTask(Name: self.symbol) { (result) in
            
            switch result {
            case .success(let rep): stock = rep
            default: break
            }
            
            wsexpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNotNil(stock)
            print("History Task for \(self.symbol) :\n \(stock!)")
        }
    }
    
    func testDetailTask() throws {
        
        let wsexpectation = expectation(description: "Detail Task")
        var stock : StockDetail?
        
        self.ws.detailsTask(Symbol: self.symbol) { (result) in
            
            switch result {
            case .success(let rep): stock = rep
            default: break
            }
            
            wsexpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNotNil(stock)
            print("History Task for \(self.symbol) :\n \(stock!)")
        }
    }

}
