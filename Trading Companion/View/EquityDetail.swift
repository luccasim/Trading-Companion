//
//  EquityDetail.swift
//  Trading Companion
//
//  Created by owee on 30/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI
import Combine

struct EquityDetail: View {
    
    var model : Equity
    
    @State private var inputSupport : Double?
    @State private var inputEntry   : Double?
        
    @State private var lock : Bool = true
    
    var body: some View {
                    
            Form {
                
                Section(header: Text("Informations")) {
                    
                    TextView(label: "Cours", value: model.close)
                    
                    NumberFieldView(label: "Support", value: self.$inputSupport, lock: lock)
                }
                
                Section(header: Text("Indicateurs")) {
                    
                    DoubleTextView(label: "Tendance", value: 0)
                    
                    DoubleTextView(label: "MM20", value: 0)
                    
                }
                
                Section(header: Text("Simulations")) {
                    
                    SimulationView(lock: lock, objectif: self.$inputEntry)
                }
                
                Section(header: Text("Actions")) {
                    
                    Button(action: {self.lock.toggle()}) {
                        if self.lock {
                            Text("Edit")
                        } else {
                            Text("Lock")
                        }
                    }
                }
            }
            .navigationBarTitle("\(model.name)")
            .onAppear() {
                self.inputEntry = self.model.entry
                print(self.inputEntry)
                self.inputSupport = self.model.support
                print(self.inputSupport)
            }
            .onDisappear(){
                self.model.entry = self.inputEntry ?? 0
                self.model.support = self.inputSupport ?? 0
        }
    }
}

struct EquityDetail_Previews: PreviewProvider {
    static var previews: some View {
        EquityDetail(model: Equity.preview)
    }
}
