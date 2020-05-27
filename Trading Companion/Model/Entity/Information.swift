//
//  index.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

public class Information : NSManagedObject {
        
    func set(fromAlphavantage data:Data) {
        
        do {
            
            let reponse = try AlphavantageWS.InformationReponse(from: data)
            
            self.symbol     = reponse.symbol
            self.name       = reponse.name
            self.type       = reponse.type
            self.region     = reponse.region
            self.currency   = reponse.currency
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension AlphavantageWS {
    
    struct InformationReponse : Codable {
        
        let symbol  : String
        let name    : String
        let type    : String
        let region  : String
        let currency: String
        
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
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: Keys.self)
                        
            self.symbol     = try container.decode(String.self, forKey: .symbol)
            self.name       = try container.decode(String.self, forKey: .name)
            self.type       = try container.decode(String.self, forKey: .type)
            self.region     = try container.decode(String.self, forKey: .region)
            self.currency   = try container.decode(String.self, forKey: .currency)
        }
        
        private struct Wrapper : Codable {
            
            let matches : [InformationReponse]
            
            enum CodingKeys: String, CodingKey {
                case matches = "bestMatches"
            }
        }
        
        init(from data:Data) throws {
            
            let decoder = JSONDecoder()
            let wrapper = try decoder.decode(Wrapper.self, from: data)
            
            self = wrapper.matches[0]
        }
    }
}
