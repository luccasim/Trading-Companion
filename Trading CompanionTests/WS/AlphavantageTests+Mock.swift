//
//  Alphavantage+Mock.swift
//  Trading CompanionTests
//
//  Created by owee on 15/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation
@testable import Trading_Companion

class AlphaMock : AlphavantageWSModel {

    var label   : String
    var detail  : AlphavantageWS.InformationReponse?
    var global  : AlphavantageWS.GlobalReponse?
    var history : AlphavantageWS.HistoryReponse?
    var rsi     : AlphavantageWS.RSIReponse?
    
    init(_ str:String) {
        self.label = str
    }
    
    func setDetail(Reponse: AlphavantageWS.InformationReponse) {
        self.detail = Reponse
    }
    
    func setGlobal(Reponse: AlphavantageWS.GlobalReponse) {
        self.global = Reponse
    }
    
    func setHistory(Reponse: AlphavantageWS.HistoryReponse) {
        self.history = Reponse
    }
    
    func setRSI(Reponse: AlphavantageWS.RSIReponse) {
        self.rsi = Reponse
    }
}
