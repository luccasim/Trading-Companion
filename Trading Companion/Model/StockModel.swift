import Foundation

public struct StockDaily : Codable {
    
    let date    : String
    let low     : Double
    let hight   : Double
    let open    : Double
    let volume  : Double
    let close   : Double
    
    init?(Date:String, Values:[String:Any]) {
        
        var lowValue    : Double?
        var hightValue  : Double?
        var openValue   : Double?
        var volValue    : Double?
        var closeValue  : Double?
        
        Values.forEach { (dict: (key: String, value: Any)) in
            
            if let str = dict.value as? String {
                
                if let value = Double(str) {
                    
                    switch dict.key {
                    case "1. open"  : openValue = value
                    case "2. high"  : hightValue = value
                    case "3. low"   : lowValue = value
                    case "4. close" : closeValue = value
                    case "5. volume": volValue = value
                    default         : break
                    }
                }
            }
        }

        guard let _lowValue = lowValue, let _hightValue = hightValue, let _openValue = openValue, let _volValue = volValue, let _closeValue = closeValue else {
            return nil
        }
        
        self.date = Date
        self.low = _lowValue
        self.hight = _hightValue
        self.open = _openValue
        self.volume = _volValue
        self.close = _closeValue

    }
    
}

public struct Stock : Codable {
    
    let symbol  : String
    let days    : [StockDaily]
  
//    let name    : String
    
//    let support     : Double
//    let resistance  : Double
//    let stopLoss    : Double
//    let purchase    : Double
//    let sell        : Double
    
    init?(fromAlphavangage:Data) {
        
        var symb : String?
        var dailies : [StockDaily] = []
        
        do {
            
            let object = try JSONSerialization.jsonObject(with: fromAlphavangage, options: [])
            
            if let json = object as? [String:Any] {
                
                
                if let meta = json["Meta Data"] as? [String:Any] {
                    
                    if let value = meta["2. Symbol"] as? String {
                        symb = value
                    }
                }
                
                if let daily = json["Time Series (Daily)"] as? [String:Any] {
                    
                    daily.forEach { (dict: (key: String, value: Any)) in
                        
                        if let values = dict.value as? [String:Any] {
                            
                            if let daily = StockDaily(Date: dict.key, Values: values) {
                                dailies.append(daily)
                            }
                        }
                    }
                }
            }
                
            guard let symb = symb, !dailies.isEmpty else {
                return nil
            }
            
            self.symbol = symb
            self.days = dailies
                

            
        } catch let error {
            print("Error -> \(error.localizedDescription)")
            return nil
        }
        
    }
    
}
