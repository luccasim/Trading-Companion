//
//  History.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

class History : NSManagedObject {
    
}

extension History {
    
    enum Errors : Error {
        case jsonSerialization
        case historyToDictonary
    }
    
    enum Keys : String {
        case meta       = "Meta Data"
        case daily      = "Time Series (Daily)"
        
        case open       = "1. open"
        case high       = "2. high"
        case low        = "3. low"
        case close      = "4. close"
        case volume     = "5. volume"
    }
    
    static func with(AlphavantageData data:Data) throws -> [History] {
        
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let dict = json as? [String:Any] else {
            throw Errors.jsonSerialization
        }
        
        guard let daily = dict[Keys.daily.rawValue] as? [String:Any] else {
            throw Errors.historyToDictonary
        }
        
        var histories : [History] = []
        
        daily.forEach({ dict in
            
            let key = dict.key
            
            if let value = dict.value as? [String:Any] {
                
                let history = History(context: AppDelegate.viewContext)
                
                let formater = DateFormatter()
                formater.dateFormat = "yyyy-MM-dd"
                
                history.date = formater.date(from: key)
                history.open = Double(value[Keys.open.rawValue] as? String ?? "0") ?? 0
                history.high = Double(value[Keys.high.rawValue] as? String ?? "0") ?? 0
                history.close = Double(value[Keys.close.rawValue] as? String ?? "0") ?? 0
                history.low = Double(value[Keys.low.rawValue] as? String ?? "0") ?? 0
                history.volume = Double(value[Keys.volume.rawValue] as? String ?? "0") ?? 0
                
                histories.append(history)
            }
        })
            
        return histories
    }
    
}
