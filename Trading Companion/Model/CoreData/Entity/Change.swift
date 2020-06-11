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
    
    static var preview : Change = {
        let obj = Change(context: AppDelegate.viewContext)
        obj.set(fromAlphavantage: AlphavantageWS.GlobalReponse.preview)
        return obj
    }()
    
    var shouldUpdate : Bool {
        return self.update == nil ? true : self.update == Date().currentStringDayDate ? false : true
    }
    
    private var fetchDay : Day {
        
        if let date = self.update?.toDate as NSDate? {
            let request : NSFetchRequest<Day> = Day.fetchRequest()
            request.predicate = NSPredicate(format: "date = %@", date)
            if let day = try? AppDelegate.viewContext.fetch(request).first {
                return day
            }
        }
        let day = Day(context: AppDelegate.viewContext)
        day.set(Change: self)
        return day
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
            self.update         = Date().currentStringDayDate
            self.day            = self.fetchDay
        }
    }
    
    convenience init(WithEquity equity:Equity) {
        self.init(context:AppDelegate.viewContext)
        self.equity = equity
    }
    
    var percentFormat : String {
        var cpy = self.percent ?? "#12"
        cpy.removeLast()
        cpy.removeLast()
        cpy.append("%")
        return cpy
    }
    
}

extension Date {
    
    var currentStringDayDate : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
