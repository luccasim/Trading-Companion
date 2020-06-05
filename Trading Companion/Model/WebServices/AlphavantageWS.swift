import Foundation
import Combine

public class AlphavantageWS {
    
    let key = "CZA8D69RROESV61Q"
    
    public init() {}
    
    private let dlqueue     = DispatchQueue(label: "Download stock List")
    private let timerQueue  = DispatchQueue.init(label: "Timer")
    private let group       = DispatchGroup()
        
    private var notDownloadList = true
    
    /// Download a list to the specific endpoint every 10 secondes
    /// - Parameters:
    ///   - Endpoint: endpoint service to call
    ///   - list: list for endpoint protocol
    ///   - Completion: Result of operation, the Error endOfUpdate mean the end of operation.
    func update(Endpoint:AlphavantageWS.Endpoint, EquitiesList list:[AlphavantageWSModel], Completion: @escaping(Result<[AlphavantageWSModel],Error>)->Void) {
        
        guard self.notDownloadList else {
            return Completion(.failure(AlphavantageWS.Errors.pendingDownload))
        }
        
        self.notDownloadList = false

        var reponses = self.mapModel(Endpoint: Endpoint, Models: list)
                        
        self.timerQueue.async {
            
            let semaphore = DispatchSemaphore(value: 0)
            
            while (!reponses.isEmpty) {
            
                guard let downloadList = reponses.first else {
                    break
                }

                let label = downloadList.model.label

                print("[\(label)] Start Download for : \(Endpoint.rawValue)  At : \(Date())")

                self.getDataTask(List: [downloadList]) { (result) in

                    switch result{
                    case .success(let datas):
                        print("[\(label)] Sucess.")
                        Completion(.success(datas.map({$0.model})))
                        reponses.removeFirst()
                    case .failure(let error):
                        
                        if case Errors.server(_, let url) = error {
                            print("[\(label)] Look -> \(url)")
                        }
                        
                        else {
                            print("[\(label)] Fail Download")
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
            
            var unvalid : Error?
                        
            List.forEach { (model) in
                
                self.group.enter()
                
                self.getDataTask(Request: model.request) { (result) in

                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {self.setDataToModel(Data: data, Reponse: model)}
                    case .failure(let error):
                        unvalid = error
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
