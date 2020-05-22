import Foundation

struct Stock : Identifiable {
    
    let symbol  : String
        
    var history : StockHistory? = nil
    var detail  : StockDetail? = nil
    var global  : StockGlobal? = nil

}

extension Stock {
    
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

extension Stock : Decodable {
    
    enum CodingKeys : CodingKey {
        case symbol, detail, history, global
    }
    
    init(from decoder:Decoder) throws {
        
        let values      = try decoder.container(keyedBy: CodingKeys.self)
        
        self.symbol     = try values.decode(String.self, forKey: .symbol)
        self.detail     = try values.decodeIfPresent(StockDetail.self, forKey: .detail)
        self.history    = try values.decodeIfPresent(StockHistory.self, forKey: .history)
        self.global     = try values.decodeIfPresent(StockGlobal.self, forKey: .global)
    }
    
    init(from JsonData:Data) throws {
        let json = JSONDecoder()
        self = try json.decode(Stock.self, from: JsonData)
    }
    
}

extension Stock : Encodable {
    
}
