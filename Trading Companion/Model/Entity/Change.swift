//
//  Change.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

class Change : NSManagedObject, Codable {
    
    enum Keys : String, CodingKey {
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
    
    required convenience init(from decoder: Decoder) throws {
        
        let container   = try decoder.container(keyedBy: Keys.self)
        let nested      = try container.nestedContainer(keyedBy: Keys.self, forKey: .global)
        
        self.init(context:AppDelegate.viewContext)
        
        self.symbol     = try nested.decode(String?.self, forKey: .symbol)
        self.open       = try nested.decode(String.self, forKey: .open).toDouble
        self.high       = try nested.decode(String.self, forKey: .high).toDouble
        self.low        = try nested.decode(String.self, forKey: .low).toDouble
        self.price      = try nested.decode(String.self, forKey: .price).toDouble
        self.volume     = try nested.decode(String.self, forKey: .volume).toDouble
        self.lastDay    = try nested.decode(String.self, forKey: .lastDay).toDate
        self.previousClose = try nested.decode(String.self, forKey: .previous).toDouble
        self.change     = try nested.decode(String.self, forKey: .change).toDouble
        self.percent    = try nested.decode(String.self, forKey: .percent)
    }
    
    static func from(AlphavantageData data:Data) throws -> Change {
        return try JSONDecoder().decode(Change.self, from: data)
    }
}

fileprivate extension String {
    
    var toDouble : Double {
        return Double(self) ?? 0
    }
    
    var toDate : Date? {
        return DateFormatter().date(from: self)
    }
}
