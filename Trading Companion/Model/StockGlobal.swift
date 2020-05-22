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
    
    struct Wrapper : Codable {
        
        let globale  : StockGlobal
        
        enum CodingKeys : String, CodingKey {
            case globale      = "Global Quote"
        }
        
        init(fromJson: [String:Any]?) throws {

            guard let json = fromJson else {
                throw Errors.cantReadData
            }
            
            guard let global = json["Global Quote"] else {
                throw Errors.missingQuoteValue
            }
            
            let data = try JSONSerialization.data(withJSONObject: global, options: [])
                
            self.globale = try JSONDecoder().decode(StockGlobal.self, from: data)
        }
    }
}

extension StockGlobal {
    
    enum Errors : Error {
        case cantReadData
        case missingQuoteValue
        case missingValue
        case convertOpenToDouble
        case convertHighToDouble
        case convertLowToDouble
        case convertPriceToDouble
        case convertLastDayToDate
        case convertPreviousToDouble
        case convertChangeToDouble
        case convertVolumeToInt
    }
    
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
    
    init(from json:[String:Any]?) throws {
        
        guard let json = json else {
            throw Errors.cantReadData
        }
        
        guard let symbol = json["01. symbol"] as? String else {
            throw Errors.missingValue
        }
        self.symbol = symbol
        
        guard let strOpen = json["02. open"] as? String, let open = Double(strOpen) else {
            throw Errors.missingValue
        }
        self.open = open
        
        guard let strHigh = json["03. high"] as? String, let high = Double(strHigh) else {
            throw Errors.missingValue
        }
        self.high = high
        
        guard let strLow = json["04. low"] as? String, let low = Double(strLow) else {
            throw Errors.convertLowToDouble
        }
        self.low = low
        
        guard let strPrice = json["05. price"] as? String, let price = Double(strPrice) else {
            throw Errors.convertPriceToDouble
        }
        self.price = price
        
        guard let strVolume = json["06. volume"] as? String, let volume = Int(strVolume) else {
            throw Errors.convertVolumeToInt
        }
        self.volume = volume
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let strLast = json["07. latest trading day"] as? String, let last = formatter.date(from: strLast) else {
            throw Errors.convertLastDayToDate
        }
        self.lastDay = last
        
        guard let strPrevious = json["08. previous close"] as? String, let previous = Double(strPrevious) else {
            throw Errors.convertPreviousToDouble
        }
        self.previous = previous
        
        guard let strChange = json["09. change"] as? String, let change = Double(strChange) else {
            throw Errors.convertChangeToDouble
        }
        self.change = change
        
        guard let percent = json["10. change percent"] as? String else {
            throw Errors.missingValue
        }
        self.percent = percent
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
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

    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.symbol, forKey: .symbol)
        try container.encode(self.open.description, forKey: .open)
        try container.encode(self.high.description, forKey: .high)
        try container.encode(self.low.description, forKey: .low)
        try container.encode(self.price.description, forKey: .price)
        try container.encode(self.volume.description, forKey: .volume)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        try container.encode(formatter.string(from: self.lastDay), forKey: .lastDay)
        try container.encode(self.previous.description, forKey: .previous)
        try container.encode(self.change.description, forKey: .change)
        try container.encode(self.percent, forKey: .percent)
    }
    
    init(fromData:Data) throws {
        
        let json = try JSONSerialization.jsonObject(with: fromData, options: []) as? [String:Any]
        
        let wrapper = try StockGlobal.Wrapper(fromJson: json)
        self = wrapper.globale
    }
}
