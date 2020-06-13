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
    
    //ViewModel
    @State var selector = 0
    @State private var value = [Value.price, Value.rsi]
    
    enum Value : String {
        case price
        case rsi
//        case mma
//        case volume
    }
    
    func displayed(Value value:Value, ForDay day:Day) -> String {
        switch value {
        case .price: return day.price
        case .rsi:   return day.rsi.toStringDecimal
//        default:
        }
    }
    
    var body: some View {
        
        Form {
            
            Picker("Value", selection: $selector) {
                ForEach(0 ..< value.count) {
                    Text(self.value[$0].rawValue).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            ForEach(self.model.allDays) { day in
                TextView(label: day.date!.toStringDay, value: self.displayed(Value: self.value[self.selector], ForDay: day))
            }
        }
    }
}

struct EquityDay_Previews: PreviewProvider {
    static var previews: some View {
        EquityDay(model: Equity.preview)
    }
}
