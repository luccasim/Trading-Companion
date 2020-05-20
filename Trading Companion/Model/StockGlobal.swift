//
//  StockGlobal.swift
//  Trading Companion
//
//  Created by owee on 20/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

struct StockGlobal : Codable {
    
    let symbol      : String
    let open        : Double
    let high        : Double
    let low         : Double
    let price       : Double
    let volume      : Int
    let lastDay     : String
    let previous    : Double
    let change      : Double
    let percent     : String
    
    enum CodingKeys : String, CodingKey {
        case symbol     = "01. symbol"
        case open       = "02. open"
        case high       = "03. high"
        case low        = "04. low"
        case price      = "05. price"
        case volume     = "06. volume"
        case lastDay    = "07. latest trading day"
        case previous   = "08. previous close"
        case change     = "09. change"
        case percent    = "10. change percent"
    }
    
}

extension StockGlobal {
    
    struct Wrapper : Codable {
        
        let day : StockGlobal
        
        enum CodingKeys : String, CodingKey {
            case day = "Global Quote"
        }
    }
}

extension StockGlobal {
    
    init(fromData:Data) throws {
        
        let decoder = JSONDecoder()
        
        let global = try decoder.decode(StockGlobal.Wrapper.self, from: fromData)
        self = global.day
    }
}
