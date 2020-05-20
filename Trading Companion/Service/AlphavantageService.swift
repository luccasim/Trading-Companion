import Foundation

public class AlphavantageService {
    
    let key = "CZA8D69RROESV61Q"
    
    private var pendingDL = false
    
    public enum APIError : Error {
        case serverSideError(Error)
        case unvalidSymbolName
        case parsingStockModel
        case parsingDetail
        case endOfList
    }
    
    public init() {}
    
    private var group = DispatchGroup()
    
    func fetchStockList(List:[String], Completion:@escaping((Result<Stock,APIError>)->Void)) {
                        
        let dlqueue = DispatchQueue(label: "Download stock List")
        
        dlqueue.async {
            
            print("Start download list")
            
            var success = 0
                        
            List.forEach { (name) in
                
                var details : StockDetail?
                var histories : StockHistory?
                
                self.detailsTask(Symbol: name) { (result) in
                    switch result {
                    case .success(let detail): details = detail
                    case .failure(let error): print("Error \(name) -> \(error.localizedDescription)")
                    }
                }
                
                self.historyTask(Name: name) { (result) in
                    switch result {
                    case .success(let history): histories = history
                    case .failure(let error): print("Error \(name) -> \(error.localizedDescription)")
                    }
                }
                
                self.group.wait()
                
                if let details = details, let history = histories {
                    let stock = Stock(history: history, detail: details)
                    Completion(.success(stock))
                    success += 1
                }
            }
            
            print("Finish download List [\(success)/\(List.count)]")
        }
    }
    
    public func historyRequest(Name:String) -> URLRequest {
        
        let uri = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(Name)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
    private func historyTask(Name:String, Completion:@escaping ((Result<StockHistory,APIError>) -> Void)) {
                
        let request = self.historyRequest(Name: Name)
        let session = URLSession(configuration: .default)
        
        self.group.enter()
        
        session.dataTask(with:request) { (data, reponse, error) in
            
            defer {
                self.group.leave()
            }
            
            if let error = error {
                Completion(.failure(.serverSideError(error)))
                return
            }
            
            if let data = data {
                
                if let str = String(data: data, encoding: .utf8) {
                    
                    if str.contains("Error Message") {
                        return Completion(.failure(.unvalidSymbolName))
                    }
                }
                
                do {
                    
                    let history = try StockHistory(fromAlphavantage: data)
                    return Completion(.success(history))
                    
                } catch let error {
                    print("Error -> \(error.localizedDescription)")
                    return Completion(.failure(.parsingDetail))
                }
                
            }
        }.resume()
    }
    
    public func detailsRequest(Symbol:String) -> URLRequest {
        
        let uri = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(Symbol)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
    private func detailsTask(Symbol:String, Completion:@escaping ((Result<StockDetail,APIError>) -> Void)) {
        
        let session = URLSession(configuration: .default)
        let request = self.detailsRequest(Symbol: Symbol)
        
        self.group.enter()
        
        session.dataTask(with: request) { (data, reponse, error) in
            
            defer {
                self.group.leave()
            }
            
            if let error = error {
                return Completion(.failure(.serverSideError(error)))
            }
            
            if let data = data {
                
                if let str = String(data: data, encoding: .utf8) {
                    
                    if str.contains("Error Message") {
                        return Completion(.failure(.unvalidSymbolName))
                    }
                    
                    do {
                        
                        let details = try StockDetail(FromData: data)
                        Completion(.success(details))
                        
                    } catch let error {
                        print("Error -> \(error.localizedDescription)")
                        Completion(.failure(.parsingDetail))
                    }
                }
            }
        }.resume()
    }
}
