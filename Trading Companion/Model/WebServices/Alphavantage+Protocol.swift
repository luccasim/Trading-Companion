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
    var setData     : ((Data)->(Void)) {get}
    
}
