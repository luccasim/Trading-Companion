//
//  SimulationView.swift
//  Trading Companion
//
//  Created by owee on 01/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct SimulationView: View {
    
    @Binding var model : Equity
    
    var entryIsSet : Bool {
        return self.model.entry != 0
    }
    
    var body: some View {
        
            VStack {
            
            NumberField(label: "Objectif", input: "0", value: self.$model.entry)
            
            
            if self.model.entry == 0 {
                    
                    HStack(alignment: .top) {
                        Text("Stop")
                        Spacer()
                        Text("0.0")
                    }
                    
                    HStack(alignment: .top) {
                        Text("S1")
                        Spacer()
                        Text("0.0")
                    }
                    
                    HStack(alignment: .top) {
                        Text("S2")
                        Spacer()
                        Text("0.0")
                    }
                    
                    HStack(alignment: .top) {
                        Text("S3")
                        Spacer()
                        Text("0.0")
                    }
                }
        }
        
    }
}

struct SimulationView_Previews: PreviewProvider {
    static var previews: some View {
        SimulationView(model: .constant(Equity.preview))
    }
}
