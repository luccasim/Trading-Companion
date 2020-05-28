//
//  Equity.swift
//  Trading Companion
//
//  Created by owee on 23/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

public class Equity : NSManagedObject, Identifiable {
    
    static var resetEquities : [Equity] {
        return EquitiesGroup.SRD.list.map { str in
            let equity = Equity(context: AppDelegate.viewContext)
            equity.symbol = str
            return equity
        }
    }
    
    static var storedEquities : [Equity] {
        do {
            return try AppDelegate.viewContext.fetch(Equity.fetchRequest())
        } catch let error {
            print(error.localizedDescription)
            return Equity.resetEquities
        }
    }
    
    func updateInformation(data:Data) {
        
        guard let information = self.information else {
            DispatchQueue.main.sync {
                self.information = Information(context: AppDelegate.viewContext)
            }
            self.information?.set(fromAlphavantage: data)
            self.information?.equity = self
            return
        }
        
        information.set(fromAlphavantage: data)
    }
        
    var shouldUpdateChange : Bool {
        return self.change == nil
    }
    
    var shouldUpdateInformation : Bool {
        return self.information == nil
    }
}

extension Equity : EquityListView {
    
    var little: String {
        return self.symbol?.components(separatedBy: ".").first ?? self.symbol ?? ""
    }
    
    var name: String {
        return self.information?.name ?? ""
    }
    
    var close: String {
        return self.change?.previousClose.description ?? ""
    }
    
    var support: String {
        return ""
    }
}

extension Equity : AlphavantageWSModel {
    
    func setDetail(Data: Data) {
        self.updateInformation(data: Data)
    }
    
    var label : String {
        return self.symbol ?? ""
    }

    
}
