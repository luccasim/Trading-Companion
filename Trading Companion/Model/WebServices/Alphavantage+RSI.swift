//
//  Alphavantage+RSI.swift
//  Trading Companion
//
//  Created by owee on 06/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

extension AlphavantageWS {
    
    func rsiModel(Model:AlphavantageWSModel) -> Reponse {
        return Reponse(model: Model.self, request: self.rsiRequest(Label: Model.label), endpoint: .rsi)
    }
    
    func rsiRequest(Label:String) -> URLRequest {
        
        let symbol = Label.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? Label
        let uri = "https://www.alphavantage.co/query?function=RSI&symbol=\(symbol)&interval=daily&time_period=10&series_type=open&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        let request = URLRequest(url: url)
        return request
    }
    
    struct RSIReponse : Decodable {
        
        let result      : [RSI]
        
        enum Key : String, CodingKey {
            case result = "Technical Analysis: RSI"
        }
        
        init(from decoder:Decoder) throws {
            
            let container = try decoder.container(keyedBy: Key.self)
            
            let nested = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .result)
            
            var rsis = [RSI]()
            
            nested.allKeys.forEach { (key) in
                
                if var rsi = try? nested.decode(RSI.self, forKey: key) {
                    rsi.date = key.stringValue
                    rsis.append(rsi)
                }
            }
            
            self.result = rsis
        }

        struct RSI : Decodable {
            var date    : String?
            let rsi     : String

            enum CodingKeys : String, CodingKey {
                case rsi = "RSI"
            }
        }
        
        init(fromDataReponse data:Data) throws {
            let decoder = JSONDecoder()
            self = try decoder.decode(RSIReponse.self, from: data)
        }
    }
}
