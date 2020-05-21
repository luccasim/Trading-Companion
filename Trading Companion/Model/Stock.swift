import Foundation

struct Stock : Codable, Identifiable {
    
    let symbol  : String
        
    let history : StockHistory? = nil
    let detail  : StockDetail? = nil
    let global  : StockGlobal? = nil

}

extension Stock {
    
//    var shouldTaskHistory : Bool {
//        return self.history != nil
//    }
//
//    var shouldTaskGlobal : Bool {
//        return self.global != nil
//    }
//
//    var shouldTaskDetail : Bool {
//        return self.detail != nil
//    }
}

extension Stock {
    
    var id : Int {
        return symbol.hashValue
    }

//    var close : String {
//        return history?.close.description ?? ""
//    }

    var little : String {
        return self.symbol.components(separatedBy: ".").first ?? self.symbol
    }

//    var name    : String {
//        return detail?.name ?? ""
//    }

}
