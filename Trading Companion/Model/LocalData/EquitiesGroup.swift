//
//  SRDStocksData.swift
//  Trading Companion
//
//  Created by owee on 12/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

struct EquitiesGroup {
    
    let index   : String
    let list    : [String]
    
}

extension EquitiesGroup {
    
    static let SRD = EquitiesGroup(index: "^SBF120", list: [
        "AC.PA",
        "AF.PA",
        "AIR.PA",
        "PUB.PA",
        "ICAD.PA",
        "GLE.PAR",
        "GTT.PA",
        "OR.PA",
        "CA.PA",
        "MC.PA",
        "FP.PA",
        "EN.PA",
        "CGG.PA",
        "EUCAR.PA",
        "RNO.PA",
        "KN.PA",
        "ETL.PA",
        "CDI.PA",
        "FDJ.PA",
        "KER.PA",
        "VIV.PA",
        "UBI.PA",
        "DG.PA",
        "NXI.PA"
    ])
}
