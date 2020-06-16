//
//  Alphavantage+MM.swift
//  Trading Companion
//
//  Created by owee on 15/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

extension AlphavantageWS {
    
    func mmRequest(model:AlphavantageWSModel) -> URLRequest {
        
        let alowed = model.label.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? model.label
        let uri = "https://www.alphavantage.co/query?function=SMA&symbol=\(alowed)&interval=daily&time_period=20&series_type=open&apikey=\(self.key)"
        let url = URL(string: uri)!
        return URLRequest(url: url)
        
    }
    
    func SMAModel(model:AlphavantageWSModel) -> Reponse {
        return Reponse(model: model, request: self.mmRequest(model: model), endpoint: .mm)
    }
    
    struct SMAReponse : Codable {
        
        let result : [SMA]
        
        enum Key : String, CodingKey {
            case result = "Technical Analysis: SMA"
        }
        
        init(from decoder:Decoder) throws {
            
            let container = try decoder.container(keyedBy: Key.self)

            let nested = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .result)
            
            let keys = nested.allKeys
            var res = [SMA]()
            
            keys.forEach { (key) in
                if key.stringValue.contains("2020"), var value = try? nested.decode(SMA.self, forKey: key) {
                    value.date = key.stringValue
                    res.append(value)
                }
            }
            
            self.result = res
        }
        
        struct SMA : Codable {
            
            var date    : String?
            let mm      : String
            
            enum CodingKeys: String, CodingKey {
                case mm = "SMA"
            }
        }
        
        init(withData data:Data) throws {
            let wrapper = try JSONDecoder().decode(SMAReponse.self, from: data)
            self = wrapper
        }
        
        static var preview : SMAReponse {
            return try! AlphavantageWS.SMAReponse.init(withData: Helper.loadData(FileName: "mm.json"))
        }
    }
    
}
