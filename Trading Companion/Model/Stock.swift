import Foundation

struct Stock : Codable, Identifiable {
    
    let symbol  : String
    
    let history : StockHistory
    let detail  : StockDetail
  
//    let name    : String
//    let region  : String
    
//    let support     : Double
//    let resistance  : Double
//    let stopLoss    : Double
//    let purchase    : Double
//    let sell        : Double
}

extension Stock {
    
    var id : Int {
        return symbol.hashValue
    }
    
    var close : Double {
        return history.close
    }
}

extension Stock {
    
    enum Errors : Error {
        case MissingHistory
    }
    
//    init(Symbol:String, DataHistory:Data, Details:StockDetail) throws {
//        
//        var history : [StockDaily] = []
//
//        let object = try JSONSerialization.jsonObject(with: DataHistory, options: [])
//        
//        if let json = object as? [String:Any] {
//            
//            if let daily = json["Time Series (Daily)"] as? [String:Any] {
//                
//                daily.forEach { (dict: (key: String, value: Any)) in
//                    
//                    if let values = dict.value as? [String:Any] {
//                        
//                        if let daily = StockDaily(Date: dict.key, Values: values) {
//                            history.append(daily)
//                        }
//                    }
//                }
//            }
//        }
//        
//        guard history.isEmpty == false else {
//            throw Errors.MissingHistory
//        }
//        
//        self.symbol = Symbol
//        self.history = history
//        
//        self.name = Details.name
//        self.region = Details.region
//    }
    
}
