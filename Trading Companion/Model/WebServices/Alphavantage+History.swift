//
//  Alphavantage+History.swift
//  Trading Companion
//
//  Created by owee on 28/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

extension AlphavantageWS {
    
    public func historyRequest(Label:String) -> URLRequest {
        
        let symbol = Label.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? Label
        let uri = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(symbol)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
    
}
