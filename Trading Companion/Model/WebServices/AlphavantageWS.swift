import Foundation
import Combine

public class AlphavantageWS {
    
    let key = "CZA8D69RROESV61Q"
    
    public init() {}
    
    private let dlqueue     = DispatchQueue(label: "Download stock List")
    private let timerQueue  = DispatchQueue(label: "Timer")
    private let group       = DispatchGroup()
        
    private var notDownloadList = true
    
    /// Download a list to the specific endpoint every 10 secondes
    /// - Parameters:
    ///   - Endpoint: endpoint service to call
    ///   - list: list for endpoint protocol
    ///   - Completion: Result of operation, the Error endOfUpdate mean the end of operation.
    func update(Endpoints:[AlphavantageWS.Endpoint], EquitiesList list:[AlphavantageWSModel], Completion: @escaping(Result<[AlphavantageWSModel],Error>)->Void) {
        
        guard self.notDownloadList else {
            return Completion(.failure(AlphavantageWS.Errors.pendingDownload))
        }
        
        self.notDownloadList = false

        var modelList = list
                        
        self.timerQueue.async {
            
            let semaphore = DispatchSemaphore(value: 0)
            
            while (!modelList.isEmpty) {
            
                guard let model = modelList.first else {
                    break
                }

                let label = model.label
                let downloadList = Endpoints.compactMap({self.mapModel(Endpoint: $0, Models: [model]).first})
    
                self.getDataTask(List: downloadList) { (result) in

                    switch result{
                    case .success(let datas):
                        print("[\(label)] Sucess.")
                        Completion(.success(datas.map({$0.model})))
                        modelList.removeFirst()
                    case .failure(let error):
                        
                        if case Errors.server(_, let url) = error {
                            print("[\(label)] Look -> \(url)")
                        }
                        
                        else {
                            print("[\(label)] Failed.")
                            Completion(.failure(error))
                        }
                    }
                    semaphore.signal()
                }
                
                semaphore.wait()
                
                let _ = semaphore.wait(timeout: .now() + 10)
            }
            
            self.notDownloadList = true
            Completion(.failure(Errors.endOfUpdate))
            
        }
    }
    
    private func getDataTask(List:[Reponse], Completion:@escaping ((Result<[Reponse],Error>) -> Void)) {
        
        self.dlqueue.async {
            
            var unvalid : Error? = nil
                        
            List.forEach { (model) in
                
                self.group.enter()
                
                print("[\(model.model.label)] Call \(model.endpoint.rawValue) at \(Date())")
                
                self.getDataTask(Request: model.request) { (result) in
                    
                    DispatchQueue.main.async {
            
                        do {
                            try self.setDataToModel(Result: result, Reponse: model)
                        } catch let error {
                            unvalid = error
                        }
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
    
    private func getDataTask(Request:URLRequest, Completion:@escaping ((Result<Data,Error>) -> Void)) {
        
        let session = URLSession(configuration: .default)
                
        session.dataTask(with: Request) { (data, reponse, error) in
            
            if let error = error, let url = Request.url {
                return Completion(.failure(Errors.server(error, url.absoluteString)))
            }
            
            if let data = data {
                return Completion(.success(data))
            }
            
        }.resume()
    }
}
