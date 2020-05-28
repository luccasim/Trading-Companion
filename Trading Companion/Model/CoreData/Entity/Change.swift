//
//  Change.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

public class Change : NSManagedObject {
    
    func set(from reponse:AlphavantageWS.GlobalReponse) {
        
        self.symbol         = reponse.symbol
        self.open           = reponse.open.toDouble
        self.high           = reponse.high.toDouble
        self.low            = reponse.low.toDouble
        self.price          = reponse.price.toDouble
        self.volume         = reponse.volume.toDouble
        self.lastDay        = reponse.lastDay.toDate
        self.previousClose  = reponse.previous.toDouble
        self.change         = reponse.change.toDouble
        self.percent        = reponse.percent
        
    }
}

extension AlphavantageWS {
    
    struct GlobalReponse : Codable {
        
        let symbol      : String
        let open        : String
        let high        : String
        let low         : String
        let price       : String
        let volume      : String
        let lastDay     : String
        let previous    : String
        let change      : String
        let percent     : String
        
        enum Keys : String, CodingKey {
            
            //Wrapper
            case global     = "Global Quote"
            
            //Nested
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
        
        init(from decoder:Decoder) throws {
            
            let container   = try decoder.container(keyedBy: Keys.self)
            let nested      = try container.nestedContainer(keyedBy: Keys.self, forKey: .global)
            
            self.symbol     = try nested.decode(String.self, forKey: .symbol)
            self.open       = try nested.decode(String.self, forKey: .open)
            self.high       = try nested.decode(String.self, forKey: .high)
            self.low        = try nested.decode(String.self, forKey: .low)
            self.price      = try nested.decode(String.self, forKey: .price)
            self.volume     = try nested.decode(String.self, forKey: .volume)
            self.lastDay    = try nested.decode(String.self, forKey: .lastDay)
            self.previous   = try nested.decode(String.self, forKey: .previous)
            self.change     = try nested.decode(String.self, forKey: .change)
            self.percent    = try nested.decode(String.self, forKey: .percent)
        }
        
        init(from data:Data) throws {
            self = try JSONDecoder().decode(GlobalReponse.self, from: data)
        }
    }
}

fileprivate extension String {
    
    var toDouble : Double {
        return Double(self) ?? 0
    }
    
    var toDate : Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
}
