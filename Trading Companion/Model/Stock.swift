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
    let history : [StockDaily]
  
    let name    : String
    let region  : String
    
//    let support     : Double
//    let resistance  : Double
//    let stopLoss    : Double
//    let purchase    : Double
//    let sell        : Double
    
    var id : Int {
        return symbol.hashValue
    }
    
    var close : Double {
        return self.history.sorted {$0.date > $01.date}.first?.close ?? 42
    }
}

extension Stock {
    
    enum Errors : Error {
        case MissingHistory
    }
    
    init(Symbol:String, DataHistory:Data, Details:StockDetail) throws {
        
        var history : [StockDaily] = []

        let object = try JSONSerialization.jsonObject(with: DataHistory, options: [])
        
        if let json = object as? [String:Any] {
            
            if let daily = json["Time Series (Daily)"] as? [String:Any] {
                
                daily.forEach { (dict: (key: String, value: Any)) in
                    
                    if let values = dict.value as? [String:Any] {
                        
                        if let daily = StockDaily(Date: dict.key, Values: values) {
                            history.append(daily)
                        }
                    }
                }
            }
        }
        
        guard history.isEmpty == false else {
            throw Errors.MissingHistory
        }
        
        self.symbol = Symbol
        self.history = history
        
        self.name = Details.name
        self.region = Details.region
    }
    
}
