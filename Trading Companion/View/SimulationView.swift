//
//  SimulationView.swift
//  Trading Companion
//
//  Created by owee on 01/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct SimulationView: View {
    
    var simulator = Sim()
    
    @Binding var objectif       : Double
    
    @State var inputObjectif    : String = ""
    
    var validInput : Bool {
        if let value = Double(inputObjectif) {
            self.objectif = value
            self.simulator.calcul(Objectif: value)
            return true
        }
        return false
    }
    
    var body: some View {
        
        Form {
            
            NumberFieldView(label: "Objectif", value: self.$inputObjectif, lock: false)
            
            
            if validInput {
                
                HStack(alignment: .top) {
                    Text("Stop")
                    Spacer()
                    Text("\(self.simulator.stop.toString)")
                }
                
                HStack(alignment: .top) {
                    Text("R1")
                    Spacer()
                    Text("\(self.simulator.r1.toString)")
                }
                
                HStack(alignment: .top) {
                    Text("R2")
                    Spacer()
                    Text("\(self.simulator.r2.toString)")
                }
                
                HStack(alignment: .top) {
                    Text("R3")
                    Spacer()
                    Text("\(self.simulator.r3.toString)")
                }
            }
        }
        
    }
}

struct SimulationView_Previews: PreviewProvider {
    static var previews: some View {
        SimulationView(objectif: .constant(0))
    }
}

class Sim {
    
    var entry   : Double = 0
    var percent : Double = 7
    var stop    : Double = 6
    
    var r1      : Double = 0
    var r2      : Double = 0
    var r3      : Double = 0
    
    func calcul(Objectif:Double) {
        self.entry = Objectif
        self.stop = Objectif * (1 - percent.toPercent)
        self.r1 = Objectif * (1 + percent.toPercent)
        self.r2 = Objectif * (1 + percent.toPercent*2)
        self.r3 = Objectif * (1 + percent.toPercent*3)
    }
}

fileprivate extension Double {
    
    var toString : String {
        return String(format: "%.3f", self)
    }
    
    var toPercent : Double {
        return self / 100
    }
}
