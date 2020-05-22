import Foundation

struct Stock : Codable, Identifiable {
    
    let symbol  : String
        
    var history : StockHistory? = nil
    var detail  : StockDetail? = nil
    var global  : StockGlobal? = nil

}

extension Stock {
    
    mutating func update(newStock:Stock) {
        self.history    = newStock.history
        self.detail     = newStock.detail
        self.global     = newStock.global
    }
    
    var shouldUpdateHistory : Bool {
        return self.history == nil
    }
    
    var shouldUpdateGlobal : Bool {
        return self.global == nil
    }
    
    var shouldUpdateDetail : Bool {
        return self.detail == nil
    }
    
    var shouldUpdate : Bool {
        return shouldUpdateDetail || shouldUpdateGlobal || shouldUpdateHistory
    }
    
}

extension Stock {
    
    var id : Int {
        return symbol.hashValue
    }

    var close : String {
        return history?.close.description ?? ""
    }

    var little : String {
        return self.symbol.components(separatedBy: ".").first ?? self.symbol
    }

    var name    : String {
        return detail?.name ?? ""
    }

}
