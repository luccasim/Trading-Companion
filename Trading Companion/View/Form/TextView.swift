//
//  TextFormFieldView.swift
//  Trading Companion
//
//  Created by owee on 02/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct TextView: View {
    
    var label   : String
    var value   : String
    
    var body: some View {
        
        HStack(alignment: .top) {
            Text("\(self.label)")
            Spacer()
            Text("\(self.value)")
        }
    }
}

struct TextFormFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            TextView(label: "Label", value: "Value")
        }
    }
}
