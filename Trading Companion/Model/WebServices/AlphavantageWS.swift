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
    
    private var notDownloadList = true
    
    enum Endpoint : String, Codable {
        case detail
    }
    
    struct Reponse {
        let model       : AlphavantageWSModel
        let request     : URLRequest
        let endpoint    : AlphavantageWS.Endpoint
    }
    
    func update(Endpoint:AlphavantageWS.Endpoint, EquitiesList list:[AlphavantageWSModel], Completion: @escaping(Result<[AlphavantageWSModel],Error>)->Void) {
        
        guard self.notDownloadList else {
            return
        }
        
        self.notDownloadList = false

        let reponses : [Reponse]
        
        switch Endpoint {
        case .detail: reponses = list.map({self.detailReponse(Model: $0)})
        }
        
        var subList = self.splitList(for: 1, list: reponses)
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (timer) in
            
            guard let downloadList = subList.first else {
                timer.invalidate()
                return
            }
            
            let label = downloadList[0].model.label
            
            print("[\(label)] Start Download At : \(Date())")
            
            self.getDataTask(List: downloadList) { (result) in
                
                switch result{
                case .success(let datas):
                    Completion(.success(datas.map({$0.model})))
                    subList.removeFirst()
                case .failure(let error):
                    print("[\(label)] Fail Download")
                    Completion(.failure(error))
                }
            }
            
        }).fire()
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
    
    private func setData(Data:Data, Reponse:Reponse) {
        switch Reponse.endpoint {
        case .detail: Reponse.model.setDetail(Data: Data)
        }
    }
    
    private func getDataTask(List:[Reponse], Completion:@escaping ((Result<[Reponse],Error>) -> Void)) {
        
        self.dlqueue.async {
            
            var unvalid : Error?
                        
            List.forEach { (model) in
                
                self.group.enter()
                
                self.getDataTask(Request: model.request) { (result) in

                    switch result {
                    case .success(let data): self.setData(Data: data, Reponse: model)
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
