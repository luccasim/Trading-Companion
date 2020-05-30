//
//  index.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

fileprivate let localData = load(FileName: "information.json")

public class Information : NSManagedObject {
    
    static var previous = Information.local
    
    static var local : Information {
        let obj = Information(context: AppDelegate.viewContext)
        obj.set(fromAlphavantage: try! AlphavantageWS.InformationReponse(from: localData))
        return obj
    }
        
    func set(fromAlphavantage reponse:AlphavantageWS.InformationReponse) {
        
        self.symbol     = reponse.symbol
        self.name       = reponse.name
        self.type       = reponse.type
        self.region     = reponse.region
        self.currency   = reponse.currency

    }
}
