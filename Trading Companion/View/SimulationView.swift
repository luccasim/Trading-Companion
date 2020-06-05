//
//  SimulationView.swift
//  Trading Companion
//
//  Created by owee on 01/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct SimulationView: View {
    
    var lock = false
    var simulator = Sim()
    
    @Binding var objectif       : String
        
    var validInput : Bool {
        if let value = Double(objectif) {
            self.simulator.calcul(Objectif: value)
            return true
        }
        return false
    }
    
    var body: some View {
        
        Group {
            
            NumberFieldView(label: "Objectif", input: self.$objectif, lock: self.lock)
            
            if validInput {
                
                DoubleTextView(label: "Stop", value: self.simulator.stop)
                
                DoubleTextView(label: "R1", value: self.simulator.r1)
                
                DoubleTextView(label: "R2", value: self.simulator.r2)
                
                DoubleTextView(label: "R3", value: self.simulator.r3)
            }
        }
    }
    
}

struct SimulationView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SimulationView(objectif: .constant("0"))
        }
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

extension Double {
    
    var toString : String {
        return String(format: "%.3f", self)
    }
    
    var toPercent : Double {
        return self / 100
    }
}
