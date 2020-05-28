import Foundation
import Combine

public class AlphavantageWS {
    
    let key = "CZA8D69RROESV61Q"
    
    public init() {}
    
    let dlqueue     = DispatchQueue(label: "Download stock List")
    let group       = DispatchGroup()
    let semaphore   = DispatchSemaphore(value: 0)
    
    func splitList(for lenght:Int, list:[Reponse]) -> [[Reponse]] {
        
        var tmp : [Reponse] = []
        var result : [[Reponse]] = []
        
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
    
    enum Endpoint : String, Codable {
        case detail
    }
    
    struct Reponse {
        let model       : AlphavantageWSModel
        let request     : URLRequest
        let endpoint    : AlphavantageWS.Endpoint
    }
    
    func update(Endpoint:AlphavantageWS.Endpoint, EquitiesList list:[AlphavantageWSModel], Completion: @escaping(Result<[AlphavantageWSModel],Error>)->Void) {
        
        guard self.notPendingDownload else {
            return
        }
        
        let reponses : [Reponse]
        
        switch Endpoint {
        case .detail: reponses = list.map({self.detailReponse(Model: $0)})
        }
        
        var subList = self.splitList(for: 5, list: reponses)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (timer) in
            
            guard let downloadList = subList.first else {
                self.timer?.invalidate()
                self.timer = nil
                return
            }
            
            print("Start Download At : \(Date())")
            
            self.getDataTask(List: downloadList) { (result) in
                
                switch result{
                case .success(let datas):
                    Completion(.success(datas.map({$0.model})))
                    subList.removeFirst()
                case .failure(let error): Completion(.failure(error))
                }
            }
        })
        
        self.timer?.fire()
    }
    
    private func getDataTask(Request:URLRequest, Completion:@escaping ((Result<Data,Error>) -> Void)) {
        
        let session = URLSession(configuration: .default)
                
        session.dataTask(with: Request) { (data, reponse, error) in
            
            if let error = error {
                return Completion(.failure(error))
            }
            
            if let data = data {
                return Completion(.success(data))
            }
            
        }.resume()
    }
    
    private func getDataTask(List:[Reponse], Completion:@escaping ((Result<[Reponse],Error>) -> Void)) {
        
        self.dlqueue.async {
            
            var unvalid : Error?
                        
            List.forEach { (model) in
                
                self.group.enter()
                
                self.getDataTask(Request: model.request) { (result) in

                    switch result {
                    case .success(let data): model.model.setData(data)
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
}

