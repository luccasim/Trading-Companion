import Foundation

public class AlphavantageService {
    
    let key = "CZA8D69RROESV61Q"
    
    public enum APIError : Error {
        case serverSideError(Error)
        case unvalidSymbolName
    }
    
    public init() {}
        
    public func stockURLRequest(Name:String) -> URLRequest {
        
        let uri = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(Name)&apikey=\(key)"
        
        let url = URL(string: uri)!
        return URLRequest(url: url)
    }
    
    public func taskEquityDailyTime(StockName:String, Completion:@escaping ((Result<Data,APIError>) -> Void)) {
        
        let request = self.stockURLRequest(Name: StockName)
        
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
                
                Completion(.success(data))
                return
            }
            
        }.resume()
        
    }
    
}
