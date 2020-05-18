import Foundation

struct StockDetail : Codable {
    
    let name    : String
    let region  : String
    
}

extension StockDetail {
    
    enum DataError : Error {
        case NoFindNameKey
        case NoFindRegionKey
    }
    
    init(Symbol:String, Data:Data) throws {
        
        var dataName    : String?
        var dataRegion  : String?
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: Data, options: []) as? [String:Any]
            
            if let matches = json?["bestMatches"] as? [[String:Any]] {
                
                matches.forEach { (dict:[String : Any]) in
                    
                    if let key = dict["1. symbol"] as? String {
                        
                        if key.contains(Symbol) {
                            dataName = dict["2. name"] as? String
                            dataRegion = dict["4. region"] as? String
                        }
                    }
                }
            }
            
        } catch let error {
            print("Error -> \(error)")
            throw error
        }
        
        guard let region = dataRegion else {
            throw DataError.NoFindRegionKey
        }
        
        guard let name = dataName else {
            throw DataError.NoFindNameKey
        }
        
        self.region = region
        self.name = name
    }
}
