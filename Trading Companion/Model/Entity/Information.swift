//
//  index.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

public class Information : NSManagedObject {
        
    func set(fromAlphavantage data:Data) {
        
        do {
            
            let reponse = try AlphavantageWS.InformationReponse(from: data)
            
            self.symbol     = reponse.symbol
            self.name       = reponse.name
            self.type       = reponse.type
            self.region     = reponse.region
            self.currency   = reponse.currency
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
