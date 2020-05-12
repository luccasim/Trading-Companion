import Foundation

struct StockDaily : Codable {
    
    let date    : String
    let low     : Double
    let hight   : Double
    let open    : Double
    let volume  : Double
    let close   : Double
    
}

struct Stock : Codable, Identifiable {
    
    var id : Int {
        return symbol.hashValue
    }
    
    let symbol  : String
    let days    : [StockDaily]
  
//    let name    : String
    
//    let support     : Double
//    let resistance  : Double
//    let stopLoss    : Double
//    let purchase    : Double
//    let sell        : Double
        
}
