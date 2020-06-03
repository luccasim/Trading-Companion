//
//  NumberField.swift
//  Trading Companion
//
//  Created by owee on 01/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI
import Combine

struct NumberFieldView: View {
    
    let label    : String
                
    @Binding var input      : String
    
    var lock                : Bool = false
    
    var body: some View {
        
        HStack {
            Text("\(label)")
            TextField("0.000", text: $input)
                .multilineTextAlignment(.trailing)
                .disabled(lock)
        }
    }
}

struct NumberField_Previews: PreviewProvider {
        
    static var previews: some View {
        
        Group {
            
            Form {
                NumberFieldView(label: "Label", input: .constant("3"))
            }
            
            List {
                NumberFieldView(label: "Label", input: .constant(""))
            }
        }
    }
}
