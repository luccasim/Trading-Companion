import Foundation

struct Stock : Codable, Identifiable {
        
    let history : StockHistory
    let detail  : StockDetail

}

extension Stock {
    
    var id : Int {
        return symbol.hashValue
    }
    
    var close : Double {
        return history.close
    }
    
    var symbol : String {
        return detail.symbol
    }
    
    var name    : String {
        return detail.name
    }
}

extension Stock {
    
    enum Errors : Error {
        case MissingHistory
    }
}
