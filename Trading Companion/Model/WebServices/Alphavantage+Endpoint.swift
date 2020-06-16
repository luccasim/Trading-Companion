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
    func setRSI(Reponse:AlphavantageWS.RSIReponse)
    func setSMA(Reponse:AlphavantageWS.SMAReponse)
    
}

extension AlphavantageWS {
    
    enum Endpoint : String {
        case detail
        case global
        case history
        case rsi
        case mm
    }
    
    struct Reponse {
        let model       : AlphavantageWSModel
        let request     : URLRequest
        let endpoint    : AlphavantageWS.Endpoint
    }
    
    func setDataToModel(Result:Result<Data,Error>, Reponse:Reponse) throws {
        
        let data = try Result.get()
        
        switch Reponse.endpoint {
        case .detail:   Reponse.model.setDetail(Reponse: try AlphavantageWS.InformationReponse(from: data))
        case .global:   Reponse.model.setGlobal(Reponse: try AlphavantageWS.GlobalReponse(from: data))
        case .history:  Reponse.model.setHistory(Reponse: try AlphavantageWS.HistoryReponse(from: data))
        case .rsi:      Reponse.model.setRSI(Reponse: try AlphavantageWS.RSIReponse(fromDataReponse: data))
        case .mm:       Reponse.model.setSMA(Reponse: try AlphavantageWS.SMAReponse(withData: data))
        }
    }
    
    func mapModel(Endpoint:Endpoint, Models:[AlphavantageWSModel]) -> [Reponse] {
        
        switch Endpoint {
        case .detail:   return Models.map({self.detailReponse(Model: $0)})
        case .global:   return Models.map({self.globalReponse(Model: $0)})
        case .history:  return Models.map({self.historyReponse(Model: $0)})
        case .rsi:      return Models.map({self.rsiModel(Model: $0)})
        case .mm:       return Models.map({self.SMAModel(model: $0)})
        }
    }
}

extension AlphavantageWS {
    
    enum Errors : Error {
        case server(Error,String)
        case pendingDownload
        case missingMatchesDetails
        case endOfUpdate
    }
}
