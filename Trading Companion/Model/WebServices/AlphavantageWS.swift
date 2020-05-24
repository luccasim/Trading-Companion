import Foundation
import Combine

public class AlphavantageWS {
    
    let key = "CZA8D69RROESV61Q"
        
    public enum APIError : Error {
        case serverSideError(Error)
        case unvalidSymbolName
        case parsingStockModel
        case parsingDetail
        case endOfList
    }
    
    public init() {}
    
    let dlqueue = DispatchQueue(label: "Download stock List")
    let group   = DispatchGroup()
    
    func updateStock(OldStock:Stock, Completion:@escaping((Result<Stock,Error>)->Void)) {
        
        dlqueue.async {
            
            var details : StockDetail?
            var histories : StockHistory?
            var globals : StockGlobal?
            
            self.group.enter()
            print("Start Global Task")
            
            self.globalTask(Symbol: OldStock.symbol) { (result) in
                switch result {
                case .success(let global): globals = global
                case .failure(let error): print("[\(OldStock.symbol)] Global Task Error : \(error.localizedDescription)")
                }
                self.group.leave()
            }
            
            if OldStock.shouldUpdateDetail {
                
                self.group.enter()
                print("Start Details Task")
                
                self.detailsTask(Symbol: OldStock.symbol) { (result) in
                    switch result {
                    case .success(let detail): details = detail
                    case .failure(let error): print("[\(OldStock.symbol)] Detail Task Error : \(error.localizedDescription)")
                    }
                    self.group.leave()
                }
            }
            
            if OldStock.shouldUpdateHistory {
                
                self.group.enter()
                print("Start History Task")
                
                self.historyTask(Name: OldStock.symbol) { (result) in
                    switch result {
                    case .success(let history): histories = history
                    case .failure(let error): print("[\(OldStock.symbol)] History Task Error : \(error.localizedDescription)")
                    }
                    self.group.leave()
                }
            }
            
            self.group.wait()
            
            let stock = Stock(symbol: OldStock.symbol, history: histories, detail: details, global: globals)
            
            Completion(.success(stock))
        }
    }
    
    public func globalRequest(Symbol:String) -> URLRequest {
        
        let symbol = Symbol.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? Symbol
        let uri = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(symbol)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
    var globalSession : URLSession?
    
    func globalTask(Symbol:String, Completion:@escaping ((Result<StockGlobal,Error>) -> Void)) {
        
        let request = self.globalRequest(Symbol: Symbol)
        self.globalSession = URLSession(configuration: .default)
                
        self.globalSession?.dataTask(with: request) { (data, rep, error) in
            
            if let error = error {
                return Completion(.failure(error))
            }
            
            if let data = data {
                
                do {
                    
                    let global = try StockGlobal(fromData: data)
                    Completion(.success(global))
                    
                } catch let error {
                    return Completion(.failure(error))
                }
            }
            
        }.resume()
    }
    
    public func historyRequest(Name:String) -> URLRequest {
        
        let uri = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(Name)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
    var historySession : URLSession?
    
    func historyTask(Name:String, Completion:@escaping ((Result<StockHistory,Error>) -> Void)) {
                
        let request = self.historyRequest(Name: Name)
        self.historySession = URLSession(configuration: .default)
                
        self.historySession?.dataTask(with:request) { (data, reponse, error) in
            
            if let error = error {
                Completion(.failure(APIError.serverSideError(error)))
                return
            }
            
            if let data = data {
                
                if let str = String(data: data, encoding: .utf8) {
                    
                    if str.contains("Error Message") {
                        return Completion(.failure(APIError.unvalidSymbolName))
                    }
                }
                
                do {
                    
                    let history = try StockHistory(fromAlphavantage: data)
                    return Completion(.success(history))
                    
                } catch let error {
                    return Completion(.failure(error))
                }
                
            }
        }.resume()
    }
    
    var detailSession : URLSession?
    
    public func detailsRequest(Symbol:String) -> URLRequest {
        
        let uri = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(Symbol)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
    func detailsTask(Symbol:String, Completion:@escaping ((Result<StockDetail,Error>) -> Void)) {
        
        self.detailSession = URLSession(configuration: .default)
        let request = self.detailsRequest(Symbol: Symbol)
                
        self.detailSession?.dataTask(with: request) { (data, reponse, error) in
            
            if let error = error {
                return Completion(.failure(APIError.serverSideError(error)))
            }
            
            if let data = data {
                
                if let str = String(data: data, encoding: .utf8) {
                    
                    if str.contains("Error Message") {
                        return Completion(.failure(APIError.unvalidSymbolName))
                    }
                    
                    do {
                        
                        let details = try StockDetail(FromData: data)
                        Completion(.success(details))
                        
                    } catch let error {
                        Completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
}
