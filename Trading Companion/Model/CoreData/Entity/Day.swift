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
    
}


//MARK: - Alphavantage Reponse
extension Day {
    
    func set(HistoryDay reponse:AlphavantageWS.HistoryReponse.DayReponse) {
        
        self.date   = reponse.date?.toDate
        self.open   = reponse.open.toDouble
        self.close  = reponse.close.toDouble
        self.high   = reponse.high.toDouble
        self.low    = reponse.low.toDouble
        self.volume = reponse.volume.toDouble
        
    }
    
}
