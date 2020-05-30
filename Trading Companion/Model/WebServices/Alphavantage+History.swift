//
//  Alphavantage+History.swift
//  Trading Companion
//
//  Created by owee on 28/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

extension AlphavantageWS {
    
    func historyReponse(Model:AlphavantageWSModel) -> Reponse {
        return Reponse(model: Model, request: globalRequest(Label: Model.label), endpoint: .global)
    }
    
    public func historyRequest(Label:String) -> URLRequest {
        
        let symbol = Label.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? Label
        let uri = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(symbol)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
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
