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
    
    func setDetail(Data:Data)
    func setGlobal(Data:Data)
    
}

extension AlphavantageWS {
    
    enum Endpoint {
        case detail
        case global
    }
    
    struct Reponse {
        let model       : AlphavantageWSModel
        let request     : URLRequest
        let endpoint    : AlphavantageWS.Endpoint
    }
    
    func setDataToModel(Data:Data, Reponse:Reponse) {
        switch Reponse.endpoint {
        case .detail: Reponse.model.setDetail(Data: Data)
        case .global: Reponse.model.setGlobal(Data: Data)
        }
    }
    
    func mapModel(Endpoint:Endpoint, Models:[AlphavantageWSModel]) -> [Reponse] {
        switch Endpoint {
        case .detail:   return Models.map({self.detailReponse(Model: $0)})
        case .global:   return Models.map({self.globalReponse(Model: $0)})
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
