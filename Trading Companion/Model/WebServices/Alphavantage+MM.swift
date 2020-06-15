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
    
}
