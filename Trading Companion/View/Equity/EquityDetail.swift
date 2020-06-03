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
    @State private var inputEntry   : String = ""
    
    @State private var lock : Bool = true
    
    func setInput() {
        
        self.inputSupport = self.model.support == 0 ? "" : self.model.support.toString
        self.inputEntry = self.model.entry == 0 ? "" : self.model.support.toString
    }
    
    func saveModel() {
        
        if let value = Double(self.inputSupport) {
            self.model.support = value
            print("Support saved")
        }
        if let value = Double(self.inputEntry) {
            self.model.entry = value
            print("Objectif saved")
        }
    }
    
    func editAction() {
        self.lock.toggle()
        self.actionButtonName = self.lock ? "Edit" : "Lock"
    }
    
    @State var actionButtonName = "Edit"
    
    var body: some View {
                    
            Form {
                
                Section(header: Text("Informations")) {
                    
                    TextView(label: "Cours", value: model.close)
                    
                    NumberFieldView(label: "Support", input: self.$inputSupport, lock: lock)
                }
                
                Section(header: Text("Indicateurs")) {
                    
                    DoubleTextView(label: "Tendance", value: 0)
                    
                    DoubleTextView(label: "MM20", value: 0)
                    
                }
                
                Section(header: Text("Simulations")) {
                    
                    SimulationView(lock: lock, objectif: self.$inputEntry)
                }
                
                Section(header: Text("Actions")) {
                    
                    Button(action: {self.editAction()}) {Text(self.actionButtonName)}
                }
            }
            .navigationBarTitle("\(model.name)")
            .onAppear() {
                self.setInput()
            }
            .onDisappear(){
                self.saveModel()
            }
    }
}

struct EquityDetail_Previews: PreviewProvider {
    static var previews: some View {
        EquityDetail(model: Equity.preview)
    }
}
