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
    
    func update(Equity eq:Equity, Completion:@escaping((Result<Data,Error>)->Void)) {
        
        if let symbol = eq.symbol, eq.shouldUpdateInformation {
            
            self.detailsTask(Symbol: symbol) { (result) in
                
                switch result {
                case .success(let data): Completion(.success(data))
                default: break
                }
                
            }
        }
    }
    
    public func globalRequest(Symbol:String) -> URLRequest {
        
        let symbol = Symbol.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? Symbol
        let uri = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(symbol)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
        
    func globalTask(Symbol:String, Completion:@escaping ((Result<Data,Error>) -> Void)) {
        
        let request = self.globalRequest(Symbol: Symbol)
                
        URLSession(configuration: .default).dataTask(with: request) { (data, rep, error) in
            
            if let error = error {
                return Completion(.failure(error))
            }
            
            if let data = data {
                
                if let str = String(data: data, encoding: .utf8) {
                    if str.contains("Error Message") || str.contains("Note") {
                        return Completion(.failure(APIError.unvalidSymbolName))
                    }
                }
                
                return Completion(.success(data))
            }
            
        }.resume()
    }
    
    public func historyRequest(Symbol:String) -> URLRequest {
        
        let symbol = Symbol.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? Symbol
        let uri = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(symbol)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
    var historySession : URLSession?
    
    func historyTask(Name:String, Completion:@escaping ((Result<Data,Error>) -> Void)) {
                
        let request = self.historyRequest(Symbol: Name)
        self.historySession = URLSession(configuration: .default)
                
        self.historySession?.dataTask(with:request) { (data, reponse, error) in
            
            if let error = error {
                Completion(.failure(APIError.serverSideError(error)))
                return
            }
            
            if let data = data {
                
                if let str = String(data: data, encoding: .utf8) {
                    if str.contains("Error Message") || str.contains("Note") {
                        return Completion(.failure(APIError.unvalidSymbolName))
                    }
                }
                
                return Completion(.success(data))
            }
            
        }.resume()
    }
    
    var detailSession : URLSession?
    
    public func detailsRequest(Symbol:String) -> URLRequest {
        
        let symbol = Symbol.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? Symbol
        let uri = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(symbol)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
    func detailsTask(Symbol:String, Completion:@escaping ((Result<Data,Error>) -> Void)) {
        
        self.detailSession = URLSession(configuration: .default)
        let request = self.detailsRequest(Symbol: Symbol)
                
        self.detailSession?.dataTask(with: request) { (data, reponse, error) in
            
            if let error = error {
                return Completion(.failure(APIError.serverSideError(error)))
            }
            
            if let data = data {
                
                if let str = String(data: data, encoding: .utf8) {
                    if str.contains("Error Message") || str.contains("Note") {
                        return Completion(.failure(APIError.unvalidSymbolName))
                    }
                }
                
                return Completion(.success(data))
            }
        }.resume()
    }
}
