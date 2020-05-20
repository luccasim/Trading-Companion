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
    let lastDay     : Date
    let previous    : Double
    let change      : Double
    let percent     : String
    
}

extension StockGlobal {
    
    enum Errors : Error {
        case convertOpenToDouble
        case convertHighToDouble
        case convertLowToDouble
        case convertPriceToDouble
        case convertLastDayToDate
        case convertPreviousToDouble
        case convertChangeToDouble
        case convertVolumeToInt
    }
    
    enum StockKeys : String, CodingKey {
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
    
    enum WrapperKeys : String, CodingKey {
        case day        = "Global Quote"
    }
    
    init(from decoder: Decoder) throws {
        
        let wrapper = try decoder.container(keyedBy: WrapperKeys.self)
        
        let container = try wrapper.nestedContainer(keyedBy: StockKeys.self, forKey: .day)
        
        self.symbol = try container.decode(String.self, forKey: .symbol)
        
        guard let open = Double(try container.decode(String.self, forKey: .open)) else {
            throw Errors.convertOpenToDouble
        }
        self.open = open
        
        guard let high = Double(try container.decode(String.self, forKey: .high)) else {
            throw Errors.convertHighToDouble
        }
        self.high = high
        
        guard let low = Double(try container.decode(String.self, forKey: .low)) else {
            throw Errors.convertLowToDouble
        }
        self.low = low
        
        guard let price = Double(try container.decode(String.self, forKey: .price)) else {
            throw Errors.convertPriceToDouble
        }
        self.price = price
        
        guard let volume = Int(try container.decode(String.self, forKey: .volume)) else {
            throw Errors.convertVolumeToInt
        }
        self.volume = volume
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let last = formatter.date(from: try container.decode(String.self, forKey: .lastDay)) else {
            throw Errors.convertLastDayToDate
        }
        self.lastDay = last
        
        guard let previous = Double(try container.decode(String.self, forKey: .previous)) else {
            throw Errors.convertPreviousToDouble
        }
        self.previous = previous
        
        guard let change = Double(try container.decode(String.self, forKey: .change)) else {
            throw Errors.convertChangeToDouble
        }
        self.change = change
            
        self.percent = try container.decode(String.self, forKey: .percent)
    }
    
    init(fromData:Data) throws {
        
        let decoder = JSONDecoder()
        
        self = try decoder.decode(StockGlobal.self, from: fromData)
    }
}
