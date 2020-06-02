//
//  NumberField.swift
//  Trading Companion
//
//  Created by owee on 01/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct NumberFieldView: View {
    
    var label    : String
            
    @Binding var value  : String
    @State var lock     : Bool = false
    
    var body: some View {
        
        HStack {
            Text("\(label)")
            TextField("0.00", text: $value)
                .multilineTextAlignment(.trailing)
                .disabled(lock)
        }
    }
}

struct NumberField_Previews: PreviewProvider {
        
    static var previews: some View {
        
        Group {
            
            Form {
                NumberFieldView(label: "Label", value: .constant(""))
            }
            
            List {
                NumberFieldView(label: "Label", value: .constant(""))
            }
        }
    }
}
