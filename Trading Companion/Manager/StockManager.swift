import Foundation

public class StockManager {
    
    var stocks : [Stock] = []
    
    public init() {}
    
    public static let shared = StockManager()
    
    public let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("StockManager")
    
    func retrive() {
        
        guard let data = UserDefaults.standard.data(forKey: "Stock.Key") else {
            return
        }
        
        do {
            
            let decoder = PropertyListDecoder()
            self.stocks = try decoder.decode([Stock].self, from: data)
            
        } catch let error {
            
            print("Error -> \(error.localizedDescription)")
        }
    }
    
    func save() {
        
        do {
            
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(self.stocks)
            UserDefaults.standard.set(data, forKey: "Stock.Key")
        
        } catch let error {
            print("Save() Error -> \(error.localizedDescription)")
        }
    }
    
    func delete() {
        UserDefaults.standard.removeObject(forKey: "Stock.Key")
    }
    
    func add(Stock:Stock) {
        self.stocks.append(Stock)
        self.save()
    }
    
    func remove(Stock:Stock) {
        if let index = self.stocks.firstIndex(where: {$0.symbol == Stock.symbol}) {
            self.stocks.remove(at: index)
            self.save()
        }
    }
    
}
