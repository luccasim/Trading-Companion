//
//  NumberField.swift
//  Trading Companion
//
//  Created by owee on 01/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct NumberFormField: View {
    
    var label    : String
    
    @State var valid    = ""
        
    @Binding var value  : String
    
    @State var lock     : Bool = false
    
    var body: some View {
        
        HStack {
            Text("\(label) \(valid)")
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
                NumberFormField(label: "Value", value: .constant(""))
            }
            
            List {
                NumberFormField(label: "Value", value: .constant(""))
            }
        }
    }
}
