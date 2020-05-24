//
//  Change.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

class Change : NSManagedObject {
    
}

extension Change {
    
    struct Reponse : Codable {
        
        let global  : Value
        
        enum CodingKeys : String, CodingKey {
            case global     = "Global Quote"
        }
        
        struct Value : Codable {
            
            let symbol  : String
            let open    : String
            let high    : String
            let low     : String
            let price   : String
            let volume  : String
            let lastDay : String
            let previous: String
            let change  : String
            let percent : String
            
            enum Keys : String, CodingKey {
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
            
            init(from decoder: Decoder) throws {
                
                let nested = try decoder.container(keyedBy: Keys.self)
                
                self.symbol = try nested.decode(String.self, forKey: .symbol)
                self.open   = try nested.decode(String.self, forKey: .open)
                self.high   = try nested.decode(String.self, forKey: .high)
                self.low    = try nested.decode(String.self, forKey: .low)
                self.price  = try nested.decode(String.self, forKey: .price)
                self.volume = try nested.decode(String.self, forKey: .volume)
                self.lastDay = try nested.decode(String.self, forKey: .lastDay)
                self.previous = try nested.decode(String.self, forKey: .previous)
                self.change = try nested.decode(String.self, forKey: .change)
                self.percent = try nested.decode(String.self, forKey: .percent)
            }
        }
    }
    
    static func with(AlphavantageData data:Data) throws -> Change {
        
        let decoder = JSONDecoder()
        let json = try decoder.decode(Reponse.self, from: data)
        
        let change = Change(context: AppDelegate.viewContext)
        
        let result = json.global
        
        change.symbol           = result.symbol
        change.open             = Double(result.open) ?? 0
        change.high             = Double(result.high) ?? 0
        change.low              = Double(result.low) ?? 0
        change.price            = Double(result.price) ?? 0
        change.volume           = Double(result.volume) ?? 0
        change.lastDay          = DateFormatter().date(from: result.lastDay)
        change.previousClose    = Double(result.previous) ?? 0
        change.change           = Double(result.change) ?? 0
        change.percent          = result.percent
        
        return change
    }
}
