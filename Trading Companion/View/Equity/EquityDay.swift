//
//  EquityDay.swift
//  Trading Companion
//
//  Created by owee on 11/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct EquityDay: View {
    
    var model : Equity
    
    var body: some View {
        
        ForEach(self.model.allDays) { day in
            TextView(label: day.label, value: day.price)
        }
    }
}

struct EquityDay_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            EquityDay(model: Equity.preview)
        }
    }
}
