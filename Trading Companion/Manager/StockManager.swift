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
            
            let decoder = JSONDecoder()
            self.stocks = try decoder.decode([Stock].self, from: data)
            print("Unarchive \(self.stocks.count) stocks.")
            
        } catch let error {
            print("Error -> \(error.localizedDescription)")
        }
    }
    
    func save() {
        
        do {
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.stocks)
            UserDefaults.standard.set(data, forKey: "Stock.Key")
            print("Save \(self.stocks.count) stocks")
            
        } catch let error {
            print("Save() Error -> \(error.localizedDescription)")
        }
    }
    
    func delete() {
        UserDefaults.standard.removeObject(forKey: "Stock.Key")
    }
    
    func add(Stock:Stock?=nil, Stocks:[Stock]?=nil) {
        
        if let stock = Stock {
            self.stocks.append(stock)
            self.save()
            print("Add \(stock.symbol) stock")
        }
        
        if let stocks = Stocks {
            self.stocks.append(contentsOf: stocks)
            self.save()
        }
    }
    
    func remove(Stock:Stock?=nil, Stocks:[Stock]?=nil, Symbols:[String]?=nil) {
        
        if let symbols = Symbols {
            symbols.forEach { (symbol) in
                if let index = self.stocks.firstIndex(where: {symbol == $0.symbol}) {
                    self.stocks.remove(at: index)
                    print("Remove \(symbol).")
                }
            }
            self.save()
        }
        
        if let stocks = Stocks {
            stocks.forEach { (s) in
                if let index = self.stocks.firstIndex(where: {$0.symbol == s.symbol}) {
                    self.stocks.remove(at: index)
                    print("Remove \(s.symbol).")
                }
            }
            self.save()
        }
        
        if let stock = Stock {
            if let index = self.stocks.firstIndex(where: {$0.symbol == stock.symbol}) {
                self.stocks.remove(at: index)
                print("Remove \(stock.symbol).")
                self.save()
            }
        }
    }
}
