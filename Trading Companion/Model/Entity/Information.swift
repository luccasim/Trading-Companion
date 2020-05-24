//
//  index.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

class Information : NSManagedObject {
    
    var reponse : Reponse?
    
}

extension Information {
    
    struct Reponse : Decodable {
        
        let matches : [Information]
        
        enum Keys : String, CodingKey {
            case matches = "bestMatches"
        }
        
        init(from decoder:Decoder) throws {

            let container = try decoder.container(keyedBy: Reponse.Keys.self)

            self.matches = try container.decode([Information].self, forKey: .matches)
        }
        
        struct Information : Decodable {
            
            let symbol      : String
            let name        : String
            let type        : String
            let region      : String
            let open        : String
            let close       : String
            let timezone    : String
            let currency    : String
            let score       : String
         
            enum CodingKeys : String, CodingKey {
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
        }
    }
    
    static func with(AlphavantageData data:Data) throws -> Information {
        
        let decoder = JSONDecoder()
        
        let result = try decoder.decode(Reponse.self, from: data)
        
        let information = Information(context: AppDelegate.viewContext)
        
        let infos = result.matches[0]
        
        information.reponse = result
        
        information.name = infos.name
        information.region = infos.region
        information.currency = infos.currency
        information.symbol = infos.symbol
        information.type = infos.type
        
        return information
    }
}
