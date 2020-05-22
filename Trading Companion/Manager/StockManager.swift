import Foundation

public class StockManager {
    
    var stocks : [Stock] = []
    
    public init() {}
    
    public static let shared = StockManager()
    
    public let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("StockManager")
    
    var verbose = true
    
    private var stocksData : [Stock] {
//        return SRDStocksData.list.map({Stock(symbol: $0, history: nil, detail: nil, global: nil)})
        return SRDStocksData.list.map({Stock(symbol: $0)})
    }
    
    private func trace(_ str:String) {
        if self.verbose {
            print("[StockManager] : \(str)")
        }
    }
    
    func retrive() {
        
        self.trace("Path \(self.fileURL.path)")
        
        do {
            
            let data    = try Data(contentsOf: self.fileURL)
            let decoder = JSONDecoder()
            self.stocks = try decoder.decode([Stock].self, from: data)
            self.trace("Unarchive \(self.stocks.count) stocks.")
            
        } catch let error {
            self.trace("Retrieve Error -> \(error.localizedDescription)")
            self.stocks = self.stocksData
        }
    }
    
    func save() {
        
        do {
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.stocks)
            try data.write(to: self.fileURL, options: .atomic)
            self.trace("Save \(self.stocks.count) stocks")
            
        } catch let error {
            self.trace("Save() Error -> \(error.localizedDescription)")
        }
    }
    
    func reset() {
        
        do {
            
            try FileManager.default.removeItem(at: self.fileURL)
            
        } catch let error {
            self.trace("Delete() Error -> \(error.localizedDescription)")
        }
    }
    
    func update(Stock:Stock) {
        
        if let index = self.stocks.firstIndex(where: {$0.symbol == Stock.symbol}) {
            self.stocks[index] = Stock
            self.trace("Updating \(Stock.symbol)")
            self.save()
        }
    }
    
    func add(Stock:Stock?=nil, Stocks:[Stock]?=nil) {
        
        if let stock = Stock {
            self.stocks.append(stock)
            self.save()
            self.trace("Add \(stock.symbol) stock")
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
                    self.trace("Remove \(symbol).")
                }
            }
            self.save()
        }
        
        if let stocks = Stocks {
            stocks.forEach { (s) in
                if let index = self.stocks.firstIndex(where: {$0.symbol == s.symbol}) {
                    self.stocks.remove(at: index)
                    self.trace("Remove \(s.symbol).")
                }
            }
            self.save()
        }
        
        if let stock = Stock {
            if let index = self.stocks.firstIndex(where: {$0.symbol == stock.symbol}) {
                self.stocks.remove(at: index)
                self.trace("Remove \(stock.symbol).")
                self.save()
            }
        }
    }
}
