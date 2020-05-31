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
    
    var inputSupport    : String = ""
    var inputEntry      : String = ""
    
    static var preview : Equity = Equity.local
    
    static var local : Equity {
        let new = Equity(context: AppDelegate.viewContext)
        new.information = Information.previous
        new.change = Change.previous
        new.symbol = new.information?.symbol
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

    func registerNewSimulation() {
        
        if let value = Double(self.inputSupport) {
            self.support = value
        }
        
        if let value = Double(self.inputEntry) {
            self.entry = value
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
    
    var alert: String {
        return self.support == 0 ? "" : self.support.description
    }
    
}

extension Equity : AlphavantageWSModel {
    
    func setHistory(Reponse: AlphavantageWS.HistoryReponse) {
        //Todo
    }
    
    
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
