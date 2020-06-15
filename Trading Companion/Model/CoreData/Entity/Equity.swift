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
    
    static var preview : Equity = {
        
        let new = Equity(context: AppDelegate.viewContext)
        let index = Index(context: AppDelegate.viewContext)
        
        index.symbol = "^SBF120"
        new.information = Information.previous
        new.symbol = new.information?.symbol
        new.index = index
        new.setRSI(Reponse: AlphavantageWS.RSIReponse.preview)
        new.setHistory(Reponse: AlphavantageWS.HistoryReponse.preview)
        
        return new
    }()
    
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
    
    var allDays : [Day] {
        guard let allObj = self.days?.allObjects as? [Day], allObj.count > 0 else { return [] }
        return allObj.sorted(by: {$0.date! > $1.date!})
    }
        
    var shouldUpdatePrice : Bool {
        
        guard let change = self.change else {
            return true
        }
        
        return change.shouldUpdate
    }
    
    var shouldInit : Bool {
        return (self.information == nil) && (self.allDays.isEmpty)
    }
    
    private var titleFormat : String {
        
        guard let title = self.information?.name else {
            return ""
        }
        
        let sub = title.prefix(25)
        let str = String(sub)
        let format = str.components(separatedBy: " ")
        let words = format.count > 3 ? "\(format[0]) \(format[1]) \(format[2]) \(format[3])" : str
        
        self.formattedTitle = words
        
        return words
    }
}

extension Equity {
    
    var day : Day?  {
        guard self.allDays.count > 0 else {return nil}
        return self.allDays[self.indexDay]
    }
    
    var indexDay : Int {
        return self.allDays.firstIndex(where: {$0.label == self.selectedDay}) ?? 0
    }
    
    var little: String {
        
        if let index = self as? Index {
            return index.titleIndex
        }
        
        return self.symbol?.components(separatedBy: ".").first ?? self.symbol ?? ""
    }
    
    var name: String {
        return self.isIndex ? self.indexName : self.formattedTitle ?? self.titleFormat
    }
    
    var close: String {
        return self.change?.price.toStringDecimal ?? ""
    }
    
    var variation: String {
        return self.prevChangePercent
    }
    
    var prevChangePercent : String {
        return self.change?.percentFormat ?? ""
    }
    
    var indexName : String {
        return self.index?.titleIndex ?? ""
    }
    
    var isIndex : Bool {
        return self is Index
    }
    
    var lastRSI : String {
        return "peanut"
    }
}

extension Equity : AlphavantageWSModel {
    
    func setRSI(Reponse: AlphavantageWS.RSIReponse) {
        
        //Todo
//        let values = Reponse.result
//        var result = Set<Rsi>()
//
//        values.forEach { (rsi) in
//            let obj = Rsi(context: AppDelegate.viewContext)
//            obj.day = rsi.date?.toDate
//            obj.equity = self
//            obj.value = rsi.rsi.toDouble
//            result.insert(obj)
//        }
//
//        self.rsi?.addingObjects(from: result)
    }
    
    
    func setHistory(Reponse wrapper: AlphavantageWS.HistoryReponse) {
        
        wrapper.days.forEach { (value) in
            
            let day = Day.init(context: AppDelegate.viewContext)
            day.set(HistoryDay: value)
            self.addToDays(day)
        }
        
        if self.change == nil, let lastDay = self.allDays.first {
            self.change = Change(context: AppDelegate.viewContext)
            self.change?.equity = self
            self.change?.set(lastDay: lastDay)
        }
        
        if let defaultSelectedDay = self.allDays.first {
            self.selectedDay = defaultSelectedDay.label
        }
    }

    func setGlobal(Reponse Data: AlphavantageWS.GlobalReponse) {
        
        if let change = self.change {
            change.set(fromAlphavantage: Data)
        }
        
        else {
            self.change = Change(context: AppDelegate.viewContext)
            self.change?.equity = self
            self.change?.set(fromAlphavantage: Data)
        }
    }
    
    func setDetail(Reponse Data: AlphavantageWS.InformationReponse) {
        
        if let information = self.information {
            information.set(fromAlphavantage: Data)
        }
        
        else {
            self.information = Information(context: AppDelegate.viewContext)
            self.information?.equity = self
            self.information?.set(fromAlphavantage: Data)
        }
    }
    
    var label : String {
        return self.symbol ?? ""
    }
    
}

extension String {
    
    var toDouble : Double {
        return Double(self) ?? 0
    }
    
    var toDayDate : Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let safe = self.components(separatedBy: " ")
        return formatter.date(from: safe[0])
    }
    
    var toDateDayAndHour : Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
}

extension Double {
    
    var toStringDecimal : String {
        return String(format: "%.3f", self)
    }
    
    var toStringInt : String {
        return String(format: "%.0f", self)
    }
}

extension Date {
    
    var toStringDayAndHour : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    var toStringDay : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

}
