//
//  NumberField.swift
//  Trading Companion
//
//  Created by owee on 01/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct NumberField: View {
    
    var label    : String
    var input    : String
        
    @Binding var value : Double
    
    var formatter : Formatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 3
        formatter.numberStyle = .decimal
        return formatter
    }
    
    var body: some View {
        
        HStack {
            Text("\(input)")
            TextField(label, value: $value, formatter: self.formatter).multilineTextAlignment(.trailing)
        }
    }
}

struct NumberField_Previews: PreviewProvider {
        
    static var previews: some View {
        NumberField(label: "Age", input: "Age", value: .constant(1.43))
    }
}
