//
//  Change.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

/// This class should exist only if Equity has Day data.
public class Change : NSManagedObject {
    
    static var preview : Change = {
        let obj = Change(context: AppDelegate.viewContext)
        obj.set(fromAlphavantage: AlphavantageWS.GlobalReponse.preview)
        return obj
    }()
    
    var shouldUpdate : Bool {
        guard let update = self.update?.toDateDayAndHour else {return true}
        return update < Index.mandatoryUpdate
    }
    
    private var fetchDay : Day {
        
        if let date = self.update?.toDayDate as NSDate? {
            let request : NSFetchRequest<Day> = Day.fetchRequest()
            request.predicate = NSPredicate(format: "date = %@", date)
            if let day = try? AppDelegate.viewContext.fetch(request).first {
                day.set(Change: self)
                return day
            }
        }
        let day = Day(context: AppDelegate.viewContext)
        day.set(Change: self)
        self.equity?.addToDays(day)
        return day
    }
    
    func set(lastDay:Day) {
        self.open           = lastDay.open
        self.price          = lastDay.close
        self.high           = lastDay.high
        self.previousClose  = lastDay.close
        self.volume         = lastDay.volume
    }
    
    func set(fromAlphavantage reponse:AlphavantageWS.GlobalReponse) {
        
        self.symbol         = reponse.symbol
        self.open           = reponse.open.toDouble
        self.high           = reponse.high.toDouble
        self.low            = reponse.low.toDouble
        self.price          = reponse.price.toDouble
        self.volume         = reponse.volume.toDouble
        self.lastDay        = reponse.lastDay.toDayDate
        self.previousClose  = reponse.previous.toDouble
        self.change         = reponse.change.toDouble
        self.percent        = reponse.percent
        self.update         = Date().toStringDayAndHour
        self.day            = self.fetchDay
        
    }
    
    var percentFormat : String {
        guard var cpy = self.percent else {return ""}
        cpy.removeLast()
        cpy.removeLast()
        cpy.append("%")
        return cpy
    }
    
}

extension Date {
    
    
}

extension String {
    

}
