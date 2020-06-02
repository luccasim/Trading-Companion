//
//  DoubleTextFormView.swift
//  Trading Companion
//
//  Created by owee on 02/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct DoubleTextView: View {
    
    var label   : String
    var value   : Double
    
    var formatted : String {
        return String(format: "%.3f", self.value)
    }
    
    var body: some View {
        
        HStack {
            Text(self.label)
            Spacer()
            Text(self.formatted)
        }
    }
}

struct DoubleTextFormView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            DoubleTextView(label: "Value", value: 42)
        }
    }
}
