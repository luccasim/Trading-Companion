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
        let index = Index(context: AppDelegate.viewContext)
        index.symbol = "^SBF120"
        new.information = Information.previous
        new.change = Change.previous
        new.symbol = new.information?.symbol
        new.support = 108
        new.index = index
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
        
    var shouldUpdatePrice : Bool {
        
        guard let change = self.change else {
            return true
        }
        
        return change.shouldUpdate
    }
    
    var shouldInit : Bool {
        return self.information == nil
    }
    
    var titleFormat : String {
        
        guard let title = self.information?.name else {
            return ""
        }
        
        let format = title.components(separatedBy: " ")
        let words = format.count > 3 ? "\(format[0]) \(format[1]) \(format[2])" : title
        let size = words.count > 30 ? words.suffix(30).base : words
        
        self.formattedTitle = size
        
        return size
    }

}

fileprivate extension Double {
    
    var stringFormat : String {
        return String(format: "%.3f", self)
    }
}

extension Equity {
    
    var little: String {
        return self.symbol?.components(separatedBy: ".").first ?? self.symbol ?? ""
    }
    
    var name: String {
        return self.formattedTitle ?? self.titleFormat
    }
    
    var close: String {
        return self.change?.price.stringFormat ?? ""
    }
    
    var alert: String {
        return self.support == 0 ? "" : self.support.description
    }
    
    var prevChangePercent : String {
        return self.change?.percentFormat ?? "#"
    }
    
    var indexName : String {
        return self.index?.titleIndex ?? "#"
    }
    
    var gap : String {

        guard let spot = self.change?.price else {return ""}
        let sup = self.support
        let dif = ((spot - sup) / sup) * 100
        
        return String(format: "%.3f%%", dif)
    }
    
}

extension Equity : AlphavantageWSModel {
    
    func setHistory(Reponse: AlphavantageWS.HistoryReponse) {
        //Todo
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
    
    var label : String {
        return self.symbol ?? ""
    }
    
}
