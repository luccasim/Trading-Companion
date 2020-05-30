//
//  EquityDetail.swift
//  Trading Companion
//
//  Created by owee on 30/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct EquityDetail: View {
    
    let model : Equity
    
    var body: some View {
        
        VStack {
            Text(model.little)
        }
    }
    
}

struct EquityDetail_Previews: PreviewProvider {
    static var previews: some View {
        EquityDetail(model: Equity.preview)
    }
}


