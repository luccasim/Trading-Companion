//
//  History.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

public class History : NSManagedObject {
    
    func set(fromAlphavantage reponse:AlphavantageWS.HistoryReponse) {
        
        self.date   = reponse.date?.toDate
        self.open   = reponse.open.toDouble
        self.high   = reponse.high.toDouble
        self.low    = reponse.low.toDouble
        self.close  = reponse.close.toDouble
        self.volume = reponse.volume.toDouble
        
    }
}

extension AlphavantageWS {
    
    struct HistoryReponse : Codable {
        
        var date    : String?
        let open    : String
        let high    : String
        let low     : String
        let close   : String
        let volume  : String
        
        enum Keys : String, CodingKey {
            case open       = "1. open"
            case high       = "2. high"
            case low        = "3. low"
            case close      = "4. close"
            case volume     = "5. volume"
        }
        
        init(from decoder: Decoder) throws {
            
            let container   = try decoder.container(keyedBy: Keys.self)
                    
            self.open = try container.decode(String.self, forKey: .open)
            self.high = try container.decode(String.self, forKey: .high)
            self.low  = try container.decode(String.self, forKey: .low)
            self.close = try container.decode(String.self, forKey: .close)
            self.volume = try container.decode(String.self, forKey: .volume)
        }
        
        struct Wrapper : Codable {
            
            let history : [HistoryReponse]
            
            enum Keys: String, CodingKey {
                case history = "Time Series (Daily)"
            }
            
            init(from decoder:Decoder) throws {
                
                let container = try decoder.container(keyedBy: Keys.self)
                let nested = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .history)
                
                var histories = [HistoryReponse]()
                
                nested.allKeys.forEach { (key) in
                    if var history = try? nested.decode(HistoryReponse.self, forKey: key) {
                        history.date = key.stringValue
                        histories.append(history)
                    }
                }
                self.history = histories
            }
        }
        
        static func from(AlphavantageData data:Data) throws -> [HistoryReponse] {
            
            let decoder = JSONDecoder()
            let wrapper = try decoder.decode(Wrapper.self, from: data)
            
            return wrapper.history
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

struct DynamicKey : CodingKey {
    
    var intValue: Int?
    var stringValue: String

    init?(intValue: Int) {self.intValue = intValue ;self.stringValue = ""}
    init?(stringValue:String){self.stringValue = stringValue}
}
