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
                self.taskEquityDailyTime(Name:name) { (result) in
                    
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
    
    private func taskEquityDailyTime(Name:String, Completion:@escaping ((Result<Stock,APIError>) -> Void)) {
                
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
                
                self.taskSymbolInfo(Symbol: Name, Data:data) { (result) in
                    
                    switch result {
                    case .success(let stock): Completion(.success(stock))
                    case .failure(let error): Completion(.failure(error))
                    }
                }
            }
            
        }.resume()
    }
    
    private func taskSymbolInfo(Symbol:String, Data:Data, Completion:@escaping ((Result<Stock,APIError>) -> Void)) {
        
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
                        
                        guard let stock = Stock(fromAlphavangage: Data, details: details) else {
                            return Completion(.failure(.parsingStockModel))
                        }
                        
                        Completion(.success(stock))
                        
                    } catch let error {
                        print("Error -> \(error.localizedDescription)")
                        Completion(.failure(.parsingDetail))
                    }
                }
            }
            
        }.resume()
    }
}

extension StockDaily {
    
    init?(Date:String, Values:[String:Any]) {
        
        var lowValue    : Double?
        var hightValue  : Double?
        var openValue   : Double?
        var volValue    : Double?
        var closeValue  : Double?
        
        Values.forEach { (dict: (key: String, value: Any)) in
            
            if let str = dict.value as? String {
                
                if let value = Double(str) {
                    
                    switch dict.key {
                    case "1. open"  : openValue = value
                    case "2. high"  : hightValue = value
                    case "3. low"   : lowValue = value
                    case "4. close" : closeValue = value
                    case "5. volume": volValue = value
                    default         : break
                    }
                }
            }
        }

        guard let _lowValue = lowValue, let _hightValue = hightValue, let _openValue = openValue, let _volValue = volValue, let _closeValue = closeValue else {
            return nil
        }
        
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        
        guard let date = formater.date(from: Date) else {
            return nil
        }
        
        self.date = date
        self.low = _lowValue
        self.hight = _hightValue
        self.open = _openValue
        self.volume = _volValue
        self.close = _closeValue
    }
}

extension Stock {
    
    init?(fromAlphavangage:Data, details:StockDetail) {
        
        var symb : String?
        var dailies : [StockDaily] = []
        
        do {
            
            let object = try JSONSerialization.jsonObject(with: fromAlphavangage, options: [])
            
            if let json = object as? [String:Any] {
                
                
                if let meta = json["Meta Data"] as? [String:Any] {
                    
                    if let value = meta["2. Symbol"] as? String {
                        symb = value
                    }
                }
                
                if let daily = json["Time Series (Daily)"] as? [String:Any] {
                    
                    daily.forEach { (dict: (key: String, value: Any)) in
                        
                        if let values = dict.value as? [String:Any] {
                            
                            if let daily = StockDaily(Date: dict.key, Values: values) {
                                dailies.append(daily)
                            }
                        }
                    }
                }
            }
                
            guard let symb = symb, !dailies.isEmpty else {
                return nil
            }
            
            self.symbol = symb
            self.days = dailies
            self.region = details.region
            self.name = details.name
            
        } catch let error {
            print("Error -> \(error.localizedDescription)")
            return nil
        }
    }
}
