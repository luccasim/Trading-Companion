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
    
    let symbol = "AC.PA"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.ws = AlphavantageWS()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.ws = nil
    }
    
    func testGlobalRequest() throws {
        
        let request = self.ws.globalRequest(Symbol: self.symbol)
        
        if let url = request.url {
            print(url)
        }
        
        let exp = expectation(description: "Read Data")
        
        URLSession.shared.dataTask(with: request) { (data, rep, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                
                if let str = String(data: data, encoding: .utf8) {
                    print(str)
                }
            }
            
            exp.fulfill()
            
        }.resume()
        
        waitForExpectations(timeout: 30) { (error) in
        }
    }

    func testGlobalTask() throws {
        
        let wsexpectation = expectation(description: "Global Task")
        var res : Data?
        
        self.ws.globalTask(Symbol: self.symbol) { (result) in
            
            switch result {
            case .success(let data): res = data
            default: break
            }
            
            wsexpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            
        }
        
        XCTAssertNotNil(res)
        
        if let changeData = res {
            let change = try Change.from(AlphavantageData: changeData)
            print(change)
        }
    }
    
    func testHistoryRequest() throws {
        
        let request = self.ws.historyRequest(Symbol: self.symbol)
        
        if let url = request.url {
            print(url)
        }
        
        let exp = expectation(description: "Read Data")
        
        URLSession.shared.dataTask(with: request) { (data, rep, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                
                if let str = String(data: data, encoding: .utf8) {
                    print(str)
                }
            }
            
            exp.fulfill()
            
        }.resume()
        
        waitForExpectations(timeout: 30) { (error) in
        }
    }
    
    func testHistoryTask() throws {
        
        let wsexpectation = expectation(description: "History Task")
        var res : Data?
        
        self.ws.historyTask(Name: self.symbol) { (result) in
            
            switch result {
            case .success(let data): res = data
            default: break
            }
            
            wsexpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
        }
        
        XCTAssertNotNil(res)
        
        if let historyData = res {
            let history = try! History.from(AlphavantageData:historyData)
            print(history)
        }
    }
    
    func testDetailRequest() throws {
        
        let request = self.ws.detailsRequest(Symbol: self.symbol)
        
        if let url = request.url {
            print(url)
        }
        
        let exp = expectation(description: "Read Data")
        
        URLSession.shared.dataTask(with: request) { (data, rep, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                
                if let str = String(data: data, encoding: .utf8) {
                    print(str)
                }
            }
            
            exp.fulfill()
            
        }.resume()
        
        waitForExpectations(timeout: 30) { (error) in
        }
    }
    
    func testDetailTask() throws {
        
        let wsexpectation = expectation(description: "Detail Task")
        var stock : Data?
        
        self.ws.detailsTask(Symbol: self.symbol) { (result) in
            
            switch result {
            case .success(let rep): stock = rep
            default: break
            }
            
            wsexpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
        }
        
        XCTAssertNotNil(stock)
        
        if let detailData = stock {
            let information = try Information.from(AlphavantageData: detailData)
            print(information)
        }
    }

}
