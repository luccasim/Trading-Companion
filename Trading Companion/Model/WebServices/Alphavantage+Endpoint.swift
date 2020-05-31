//
//  AlphavantageWS+Reponse.swift
//  Trading Companion
//
//  Created by owee on 28/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

protocol AlphavantageWSModel : class {
    
    var label       : String {get}
    
    func setDetail(Reponse:AlphavantageWS.InformationReponse)
    func setGlobal(Reponse:AlphavantageWS.GlobalReponse)
    func setHistory(Reponse:AlphavantageWS.HistoryReponse)
    
}

extension AlphavantageWS {
    
    enum Endpoint {
        case detail
        case global
        case history
    }
    
    struct Reponse {
        let model       : AlphavantageWSModel
        let request     : URLRequest
        let endpoint    : AlphavantageWS.Endpoint
    }
    
    func setDataToModel(Data:Data, Reponse:Reponse) {
        
        do {
            
            switch Reponse.endpoint {
            case .detail: Reponse.model.setDetail(Reponse: try AlphavantageWS.InformationReponse(from: Data))
            case .global: Reponse.model.setGlobal(Reponse: try AlphavantageWS.GlobalReponse(from: Data))
            case .history: Reponse.model.setHistory(Reponse: try AlphavantageWS.HistoryReponse(from: Data))
            }
            
        } catch let error {
            print("[\(Reponse.model.label)] Error \(error.localizedDescription)")
        }
    }
    
    func mapModel(Endpoint:Endpoint, Models:[AlphavantageWSModel]) -> [Reponse] {
        
        switch Endpoint {
        case .detail:   return Models.map({self.detailReponse(Model: $0)})
        case .global:   return Models.map({self.globalReponse(Model: $0)})
        case .history:  return Models.map({self.historyReponse(Model: $0)})
        }
        
    }
}

extension AlphavantageWS {
    
    enum Errors : Error {
        case pendingDownload
        case missingMatchesDetails
        case endOfUpdate
    }
}
