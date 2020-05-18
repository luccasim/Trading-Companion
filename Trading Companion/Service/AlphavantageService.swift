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
        
    public func stockURLRequest(Name:String) -> URLRequest {
        
        let uri = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(Name)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
    public func symbolRequest(Symbol:String) -> URLRequest {
        
        let uri = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(Symbol)&apikey=\(self.key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
    func fetchEquityList(List:[String], Completion:@escaping((Result<Stock,APIError>)->Void)) {
                        
        let dlqueue = DispatchQueue(label: "Download list Equity")
        let semaphore = DispatchSemaphore(value: 0)
        
        dlqueue.async {
            
            self.pendingDL = true
            
            List.forEach { (name) in
                                
                print("Fetch Stock :\(name)")
                self.taskHistory(Name:name) { (result) in
                    
                    switch result {
                    case .success(let stock):
                        print("Get Stock :\(stock.symbol)")
                        Completion(.success(stock))
                    case .failure(let error):
                        print("Error -> \(error.localizedDescription)")
                    }
                    
                    semaphore.signal()
                }
                
                semaphore.wait()
            }
            
            Completion(.failure(.endOfList))
            self.pendingDL = false
        }
    }
    
    private func taskHistory(Name:String, Completion:@escaping ((Result<Stock,APIError>) -> Void)) {
                
        let request = self.stockURLRequest(Name: Name)
        let session = URLSession(configuration: .default)
        
        session.dataTask(with:request) { (data, reponse, error) in
            
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
                
                self.taskDetails(Symbol: Name, Data:data) { (result) in
                    
                    switch result {
                    case .success(let stock): Completion(.success(stock))
                    case .failure(let error): Completion(.failure(error))
                    }
                }
            }
            
        }.resume()
    }
    
    private func taskDetails(Symbol:String, Data:Data, Completion:@escaping ((Result<Stock,APIError>) -> Void)) {
        
        let session = URLSession(configuration: .default)
        let request = self.symbolRequest(Symbol: Symbol)
        
        session.dataTask(with: request) { (data, reponse, error) in
            
            if let error = error {
                return Completion(.failure(.serverSideError(error)))
            }
            
            if let data = data {
                
                if let str = String(data: data, encoding: .utf8) {
                    
                    if str.contains("Error Message") {
                        return Completion(.failure(.unvalidSymbolName))
                    }
                    
                    do {
                        
                        let details = try StockDetail(Symbol: Symbol, Data: data)
//                        let stock = try Stock(Symbol: Symbol, DataHistory: Data, Details: details)
//                        
//                        Completion(.success(stock))
                        
                    } catch let error {
                        print("Error -> \(error.localizedDescription)")
                        Completion(.failure(.parsingDetail))
                    }
                }
            }
            
        }.resume()
    }
}
