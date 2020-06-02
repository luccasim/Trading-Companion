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
    
    @State private var inputSupport : String = ""
    @State private var inputEntry   : Double = 0
        
    @State private var lock : Bool = true
    
    var body: some View {
                    
            Form {
                
                Section(header: Text("Informations")) {
                    
                    HStack(alignment: .top) {
                        Text("Cours")
                        Spacer()
                        Text("\(model.close)")
                    }
                    
                    
                    HStack {
                        if self.lock {
                            Text("Support")
                            Spacer()
                            Text("\(String(format: "%.3f", model.support))")
                        } else {
//                            NumberFormField(label: "Support", value: self.$inputSupport, lock: false)
                        }
                    }
                }
                
                Section(header: Text("Indicateurs")) {
                    
                    HStack(alignment: .top) {
                        Text("Tendance")
                        Spacer()
                        Text("")
                    }
                    
                    HStack(alignment: .top) {
                        Text("MM20")
                        Spacer()
                        Text("")
                    }
                    
                }
                
                Section(header: Text("Simulations")) {
                    SimulationView(objectif: self.$inputEntry)
                }
                
                Section(header: Text("Actions")) {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.lock.toggle()
                        }) {
                            if self.lock {
                                Text("Edit")
                            } else {
                                Text("Lock")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("\(model.name)")
            .onDisappear(){
                self.model.entry = 0
                self.model.support = Double(self.inputSupport) ?? 0
        }
    }
}

struct EquityDetail_Previews: PreviewProvider {
    static var previews: some View {
        EquityDetail(model: Equity.preview)
    }
}
