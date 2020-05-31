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

struct DynamicKey : CodingKey {
    
    var intValue: Int?
    var stringValue: String

    init?(intValue: Int) {self.intValue = intValue ;self.stringValue = ""}
    init?(stringValue:String){self.stringValue = stringValue}
}
