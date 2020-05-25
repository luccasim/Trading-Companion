//
//  index.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

public class Information : NSManagedObject, Codable {
        
    enum Keys : String, CodingKey {
        case symbol     = "1. symbol"
        case name       = "2. name"
        case type       = "3. type"
        case region     = "4. region"
        case open       = "5. marketOpen"
        case close      = "6. marketClose"
        case timezone   = "7. timezone"
        case currency   = "8. currency"
        case score      = "9. matchScore"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.init(context:AppDelegate.viewContext)
        
        self.symbol     = try container.decode(String.self, forKey: .symbol)
        self.name       = try container.decode(String.self, forKey: .name)
        self.type       = try container.decode(String.self, forKey: .type)
        self.region     = try container.decode(String.self, forKey: .region)
        self.currency   = try container.decode(String.self, forKey: .currency)
    }
    
    private struct Wrapper : Codable {
        let matches : [Information]
        
        enum CodingKeys: String, CodingKey {
            case matches = "bestMatches"
        }
    }
    
    static func from(AlphavantageData data:Data) throws -> Information {
        
        let decoder = JSONDecoder()
        let wrapper = try decoder.decode(Wrapper.self, from: data)
    
        return wrapper.matches[0]
    }
}
