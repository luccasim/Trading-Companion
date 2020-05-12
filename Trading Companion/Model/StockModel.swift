import Foundation

struct StockDaily : Codable {
    
    let date    : Date
    let low     : Double
    let hight   : Double
    let open    : Double
    let volume  : Double
    let close   : Double
 
    var timestamp : Double {
        return self.date.timeIntervalSinceReferenceDate
    }
}

struct Stock : Codable, Identifiable {
    
    let symbol  : String
    let days    : [StockDaily]
  
//    let name    : String
    
//    let support     : Double
//    let resistance  : Double
//    let stopLoss    : Double
//    let purchase    : Double
//    let sell        : Double
    
    var id : Int {
        return symbol.hashValue
    }
    
    var close : Double {
        return days.sorted {$0.date > $01.date}.first?.close ?? 42
    }
}
