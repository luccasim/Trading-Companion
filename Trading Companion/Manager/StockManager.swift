import Foundation

public class StockManager {
    
    private init() {
        
        self.retrive()
        
        if self.stocks.isEmpty {
            
            self.updateStock(Name: "AC.PA") { (result) in
                
                self.stocks.forEach { (s) in
                    print(s)
                }
            }
        }
    }
    
    public static let shared = StockManager()
    
    public var stocks : [Stock] = []
    
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
    
    func updateStock(Name:String, Completion: @escaping ((Result<Stock, Error>) -> Void)) {
        
        let service = AlphavantageService()
        
        service.taskEquityDailyTime(StockName: Name) { (result) in
            switch  result {
            case .failure(let error):
                Completion(.failure(error))
            case .success(let data):
                print("Data -> \(data)")
                if let stock = Stock(fromAlphavangage: data) {
                    self.stocks.append(stock)
                    Completion(.success(stock))
                }
            }
        }
    }
    
}
