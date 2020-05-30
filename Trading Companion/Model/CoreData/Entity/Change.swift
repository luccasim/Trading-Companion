//
//  Change.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

fileprivate let localData = load(FileName: "global.json")

public class Change : NSManagedObject {
    
    static var previous = Change.local
    
    static var local : Change {
        let obj = Change(context: AppDelegate.viewContext)
        obj.set(fromAlphavantage: try? AlphavantageWS.GlobalReponse(from:localData))
        return obj
    }
    
    func set(fromAlphavantage reponse:AlphavantageWS.GlobalReponse?) {
        
        if let reponse = reponse {
            self.symbol         = reponse.symbol
            self.open           = reponse.open.toDouble
            self.high           = reponse.high.toDouble
            self.low            = reponse.low.toDouble
            self.price          = reponse.price.toDouble
            self.volume         = reponse.volume.toDouble
            self.lastDay        = reponse.lastDay.toDate
            self.previousClose  = reponse.previous.toDouble
            self.change         = reponse.change.toDouble
            self.percent        = reponse.percent
        }
    }
    
    convenience init(WithEquity equity:Equity) {
        self.init(context:AppDelegate.viewContext)
        self.equity = equity
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
