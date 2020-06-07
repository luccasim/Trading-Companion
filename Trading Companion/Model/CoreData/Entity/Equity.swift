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
        new.setRSI(Reponse: AlphavantageWS.RSIReponse.preview)
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
        
        if let index = self as? Index {
            return index.titleIndex
        }
        
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
    
    var indexGap : String {
        return self.index?.gap ?? ""
    }
    
    var gap : String {

        guard let spot = self.change?.price else {return ""}
        let sup = self.support
        let dif = ((spot - sup) / sup) * 100
        
        return String(format: "%.3f%%", dif)
    }
    
    var lastRSI : String {
        
        guard let values = (self.rsi?.allObjects as? [Rsi]) else {
            return ""
        }
        
        guard let sorted = values.sorted(by: {$0.day! > $1.day!}).first else {
            return ""
        }
        
        return sorted.value.stringFormat
    }
}

extension Equity : AlphavantageWSModel {
    
    func setRSI(Reponse: AlphavantageWS.RSIReponse) {
        
        //Todo
        let values = Reponse.result
        var result = Set<Rsi>()
        
        values.forEach { (rsi) in
            let obj = Rsi(context: AppDelegate.viewContext)
            obj.day = rsi.date?.toDate
            obj.equity = self
            obj.value = rsi.rsi.toDouble
            result.insert(obj)
        }
        
        self.rsi?.addingObjects(from: result)
    }
    
    
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

extension String {
    
    var toDouble : Double {
        return Double(self) ?? 0
    }
    
    var toDate : Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let safe = self.components(separatedBy: " ")
        return formatter.date(from: safe[0])
    }
}
