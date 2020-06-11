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
        return self.date?.currentStringDayDate ?? "#"
    }
    
    var price : String {
        return self.close.toString
    }
}


//MARK: - Alphavantage Reponse
extension Day : Identifiable {
    
    func set(HistoryDay reponse:AlphavantageWS.HistoryReponse.DayReponse) {
        
        self.date   = reponse.date?.toDate
        self.open   = reponse.open.toDouble
        self.close  = reponse.close.toDouble
        self.high   = reponse.high.toDouble
        self.low    = reponse.low.toDouble
        self.volume = reponse.volume.toDouble
        
    }
    
    func set(Change change:Change) {
        
        self.date   = change.update?.toDate
        self.open   = change.open
        self.close  = change.price
        self.high   = change.high
        self.low    = change.low
        self.volume = change.volume
        
    }
}
