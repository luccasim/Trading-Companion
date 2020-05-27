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
    
    let dlqueue     = DispatchQueue(label: "Download stock List")
    let group       = DispatchGroup()
    let semaphore   = DispatchSemaphore(value: 0)
    
    func splitList(for lenght:Int, list:[Equity]) -> [[Equity]] {
        
        var tmp : [Equity] = []
        var result : [[Equity]] = []
        
        var i = 0
        var size = 0
        
        while (i < list.count) {
            
            tmp.append(list[i])
            
            size += 1
            i += 1
            
            if size == lenght {
                size = 0
                result.append(tmp)
                tmp.removeAll()
            }
        }
        
        if tmp.count > 0 {
            result.append(tmp)
        }
        
        return result
    }
    
    private var timer : Timer?
    
    var notPendingDownload : Bool {
        return self.timer == nil
    }
    
    enum Endpoint {
        case detail, global, history
    }
    
    func update(Endpoint:AlphavantageWS.Endpoint, EquitiesList list:[Equity], Completion: @escaping(Result<[Equity],Error>)->Void) {
        
        guard self.notPendingDownload else {
            return
        }
        
        var subList = self.splitList(for: 5, list: list)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (timer) in
            
            guard let downloadList = subList.first else {
                self.timer?.invalidate()
                self.timer = nil
                return
            }
            
            print("Start Download At : \(Date())")
            
            self.getDataTask(Endpoint: Endpoint, List: downloadList) { (result) in
                
                switch result{
                case .success(let datas):
                    Completion(.success(datas))
                    subList.removeFirst()
                case .failure(let error): Completion(.failure(error))
                }
            }
        })
        
        self.timer?.fire()
    }
    
    func getDataTask(Request:URLRequest, Completion:@escaping ((Result<Data,Error>) -> Void)) {
        
        let session = URLSession(configuration: .default)
                
        session.dataTask(with: Request) { (data, reponse, error) in
            
            if let error = error {
                return Completion(.failure(APIError.serverSideError(error)))
            }
            
            if let data = data {
                return Completion(.success(data))
            }
            
        }.resume()
    }
    
    private func getRequest(Endpoint:Endpoint, Symbol:String) -> URLRequest {
        switch Endpoint {
        case .detail: return self.detailsRequest(Symbol: Symbol)
        case .global: return self.globalRequest(Symbol: Symbol)
        case .history: return self.historyRequest(Symbol: Symbol)
        }
    }
    
    func getDataTask(Endpoint:Endpoint, List:[Equity], Completion:@escaping ((Result<[Equity],Error>) -> Void)) {
        
        self.dlqueue.async {
            
            var unvalid : Error?
                        
            List.forEach { (equity) in
                
                let request = self.getRequest(Endpoint: Endpoint, Symbol: equity.label)
                
                
                self.group.enter()
                
                self.getDataTask(Request: request) { (result) in

                    switch result {
                        
                    case .success(let data):
                        switch Endpoint {
                        case .detail:   equity.updateInformation(data: data)
                        default: break
                        }
                    case .failure(let error): unvalid = error
                    }
                                        
                    self.group.leave()
                    
                }
            }
            
            self.group.wait()
            
            self.group.notify(queue: .main) {
                if let error = unvalid {
                    Completion(.failure(error))
                } else {
                    Completion(.success(List))
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
}
