//
//  Index.swift
//  Trading Companion
//
//  Created by owee on 24/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
import CoreData

public class Index: Equity {

    private static var resetIndex : Index {
    
        let reset = Index(context: AppDelegate.viewContext)
        
        let equities = EquitiesGroup.SRD.list.map { symbol -> Equity in
            let eq = Equity(context: AppDelegate.viewContext)
            eq.symbol = symbol
            eq.index = reset
            return eq
        }
        
        reset.equities?.addingObjects(from: equities)
        reset.symbol = EquitiesGroup.SRD.index
        return reset
    }
    
    static var main : Index = {
        
        let value = EquitiesGroup.SRD.index
        
        let request : NSFetchRequest<Index> = Index.fetchRequest()
        request.predicate = NSPredicate(format: "symbol = %@", value)
    
        if let result = try? AppDelegate.viewContext.fetch(request), let index = result.first {
            return index
        }
        
        return resetIndex
    }()
    
    static func reset() {
        AppDelegate.viewContext.delete(Index.main)
        AppDelegate.saveContext()
    }
    
    var equitiesList : [Equity] {
        return self.equities?.allObjects as? [Equity] ?? []
    }
    
    var titleIndex : String {
        return self.symbol?.replacingOccurrences(of: "^", with: "") ?? "#"
    }
    
    var marketIsClose : Bool {
        let marketClose = "17:30:00"
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let current = formater.string(from: date)
        let limit = "\(current.components(separatedBy: " ")[0]) \(marketClose)"
        return date > formater.date(from: limit)!
    }
}
