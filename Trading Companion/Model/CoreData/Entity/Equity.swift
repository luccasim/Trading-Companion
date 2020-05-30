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
    
    static var preview : Equity = Equity.local
    
    static var local : Equity {
        let new = Equity(context: AppDelegate.viewContext)
        new.information = Information.previous
        return new
    }
    
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

        
    var shouldUpdateChange : Bool {
        
        guard let change = self.change else {
            return true
        }
        
        print(change.lastDay == Date())
        return change.lastDay == Date()
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
    
    var label : String {
        return self.symbol ?? ""
    }
    
    func setGlobal(Reponse Data: AlphavantageWS.GlobalReponse) {
        
        guard let change = self.change else {
            self.change = Change(WithEquity: self)
            self.change?.set(fromAlphavantage: Data)
            return
        }
        
        change.set(fromAlphavantage: Data)
        
    }
    
    
    func setDetail(Reponse Data: AlphavantageWS.InformationReponse) {
        
        guard let information = self.information else {
            self.information = Information(context: AppDelegate.viewContext)
            self.information?.set(fromAlphavantage: Data)
            self.information?.equity = self
            return
        }
        
        information.set(fromAlphavantage: Data)
    }
    

    
}
