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

}

extension AlphavantageWS {
    
    enum Endpoint {
        case detail
    }
    
    struct Reponse {
        let model       : AlphavantageWSModel
        let request     : URLRequest
        let endpoint    : AlphavantageWS.Endpoint
    }
    
    func setDataToModel(Data:Data, Reponse:Reponse) {
        switch Reponse.endpoint {
        case .detail: Reponse.model.setDetail(Data: Data)
        }
    }
    
}

extension AlphavantageWS {
    
    enum Errors : Error {
        case pendingDownload
    }
    
}
