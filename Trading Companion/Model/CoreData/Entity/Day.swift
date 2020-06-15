//
//  Day.swift
//  Trading Companion
//
//  Created by owee on 30/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

public class Day : NSManagedObject {
    
    var label : String {
        return self.date?.toStringDayAndHour ?? "#"
    }
    
    var dayDate : String {
        return self.date?.toStringDay ?? ""
    }
    
    var price : String {
        return self.close.toString
    }
    
    var shouldUpdateRSI : Bool {
        return self.rsi == 0
    }
    
    var shouldUpdateMM : Bool {
        return self.mm20 == 0
    }
    
    var shouldUpdate : Bool {
        return self.shouldUpdateRSI || self.shouldUpdateMM
    }
}


//MARK: - Alphavantage Reponse
extension Day : Identifiable {
    
    func set(HistoryDay reponse:AlphavantageWS.HistoryReponse.DayReponse) {
        
        self.date   = reponse.date?.toDayDate
        self.open   = reponse.open.toDouble
        self.close  = reponse.close.toDouble
        self.high   = reponse.high.toDouble
        self.low    = reponse.low.toDouble
        self.volume = reponse.volume.toDouble
        
    }
    
    func set(Change change:Change) {
        
        self.date   = change.update?.toDayDate
        self.open   = change.open
        self.close  = change.price
        self.high   = change.high
        self.low    = change.low
        self.volume = change.volume
        
    }
}
