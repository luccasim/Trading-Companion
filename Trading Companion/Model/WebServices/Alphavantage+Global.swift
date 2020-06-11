//
//  Alphavantage+Global.swift
//  Trading Companion
//
//  Created by owee on 28/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

extension AlphavantageWS {
    
    func globalReponse(Model:AlphavantageWSModel) -> Reponse {
        return Reponse(model: Model, request: globalRequest(Label: Model.label), endpoint: .global)
    }
    
    public func globalRequest(Label:String) -> URLRequest {
        
        let symbol = Label.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? Label
        let uri = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(symbol)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
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
        
        static var preview : AlphavantageWS.GlobalReponse {
            let data = Helper.loadData(FileName: "global.json")
            return try! AlphavantageWS.GlobalReponse(from: data)
        }
    }
}
