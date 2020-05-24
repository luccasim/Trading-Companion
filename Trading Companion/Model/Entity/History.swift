//
//  History.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

class History : NSManagedObject, Codable {
    
    enum Keys : String, CodingKey {
        case open       = "1. open"
        case high       = "2. high"
        case low        = "3. low"
        case close      = "4. close"
        case volume     = "5. volume"
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        let container   = try decoder.container(keyedBy: Keys.self)
                
        self.init(context:AppDelegate.viewContext)

        self.open = try container.decode(String.self, forKey: .open).toDouble
        self.high = try container.decode(String.self, forKey: .high).toDouble
        self.low  = try container.decode(String.self, forKey: .low).toDouble
        self.close = try container.decode(String.self, forKey: .close).toDouble
        self.volume = try container.decode(String.self, forKey: .volume).toDouble
    }
    
    struct Wrapper : Codable {
        
        let history : [History]
        
        enum Keys: String, CodingKey {
            case history = "Time Series (Daily)"
        }
        
        init(from decoder:Decoder) throws {
            
            let container = try decoder.container(keyedBy: Keys.self)
            
            let nested = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .history)
            
            var histories = [History]()
            
            nested.allKeys.forEach { (key) in
                if let history = try? nested.decode(History.self, forKey: key) {
                    history.date = key.stringValue.toDate
                    histories.append(history)
                }
            }
            self.history = histories
        }
    }
    
    static func from(AlphavantageData data:Data) throws -> [History] {
        
        let decoder = JSONDecoder()
        let wrapper = try decoder.decode(Wrapper.self, from: data)
        
        return wrapper.history
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

struct DynamicKey : CodingKey {
    
    var intValue: Int?
    var stringValue: String

    init?(intValue: Int) {self.intValue = intValue ;self.stringValue = ""}
    init?(stringValue:String){self.stringValue = stringValue}
}
