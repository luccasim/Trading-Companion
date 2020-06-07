//
//  History.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

fileprivate let localData = load(FileName: "history.json")

public class History : NSManagedObject {
    
    static var local : History {
        let obj = History(context: AppDelegate.viewContext)
        obj.set(fromAlphavantage: try! AlphavantageWS.HistoryReponse(from: localData))
        return obj
    }
    
    func set(fromAlphavantage reponse:AlphavantageWS.HistoryReponse) {
        
    }
}

