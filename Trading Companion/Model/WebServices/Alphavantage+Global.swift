//
//  Alphavantage+Global.swift
//  Trading Companion
//
//  Created by owee on 28/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

extension AlphavantageWS {
    
    public func globalRequest(Label:String) -> URLRequest {
        
        let symbol = Label.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? Label
        let uri = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(symbol)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
}
