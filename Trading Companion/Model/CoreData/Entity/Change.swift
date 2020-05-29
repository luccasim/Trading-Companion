//
//  Change.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

public class Change : NSManagedObject {
    
    func set(fromAlphavantage data:Data) {
        
        do {
            
            let reponse = try AlphavantageWS.GlobalReponse(from: data)
        
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
            
        } catch let error {
            print(error.localizedDescription)
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
