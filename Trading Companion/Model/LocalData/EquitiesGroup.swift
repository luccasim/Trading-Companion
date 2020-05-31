//
//  SRDStocksData.swift
//  Trading Companion
//
//  Created by owee on 12/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

let equity : Equity = Equity()

struct EquitiesGroup {
    
    let index   : String
    let list    : [String]
    
}

extension EquitiesGroup {
    
    static let SRD = EquitiesGroup(index: "^SBF120", list: [
        "AC.PA",
        "ADP.PA",
        "AIL.SG",
        "AF.PA",
        "AIR.PA",
        "AKA.PA",
        "PUB.PA",
        "33S.SG",
        "3AL.F",
        "ALO.PA",
        "ATE.PA",
        "ARG.PA",
        "ATO.PA",
        "CS.PA",
        "3GD.SG",
        "BB.PA",
        "EYWN.SG",
        "BNP.PA",
        "BOL.PA",
        "BON.PA",
        "BN.PA",
        "BVI.PA",
        "CAP.PA",
        "CARM.PA",
        "CO.PA",
        "CNP.PA",
        "COFA.PA",
        "COV.PA",
        "XCA.BE",
        "DSY.PA",
        "DBV.PA",
        "EDEN.PA",
        "EDF.PA",
        "FGR.PA",
        "ELIOR.PA",
        "ENGI.PA",
        "ERA.PA",
        "EL.PA",
        "EUQ.SG",
        "ERF.PA",
        "ENX.PA",
        "EO.PA",
        "FNAC.PA",
        "GFC.PA",
        "GET.PA",
        "GTT.PA",
        "ICAD.PA",
        "GLE.PAR",
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
