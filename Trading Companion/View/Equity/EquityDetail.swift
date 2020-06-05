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
    
    @EnvironmentObject var viewModel : EquityViewModel
    
    var model : Equity
    
    @State private var inputSupport : String = ""
    @State private var inputEntry   : String = ""
    
    @State private var lock : Bool = false
    
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
    
    func fetchLastEquityLastChange() {
        self.viewModel.fetchChange(Equity: self.model)
    }
    
    func editAction() {
        self.lock.toggle()
    }
    
    var actionName : String {
        return self.lock ? "Edit" : "Lock"
    }
    
    var body: some View {
                    
            Form {
                
                Section(header: Text("Informations")) {
                    
                    TextView(label: "Cours", value: model.close)
                    
                    TextView(label: "Variation", value: model.prevChangePercent)
                    
                    TextView(label: "Ecart", value: model.gap)
                                        
                    NumberFieldView(label: "Support", input: self.$inputSupport, lock: lock)
                }
                
                Section(header: Text("Indicateurs")) {
                    
                    TextView(label:self.model.indexName , value: self.model.indexGap)
                    
                    DoubleTextView(label: "Tendance", value: 0)
                    
                    DoubleTextView(label: "MM20", value: 0)
                    
                    DoubleTextView(label: "RSI", value: 0)
                    
                }
                
                Section(header: Text("Simulations")) {
                    
                    SimulationView(lock: lock, objectif: self.$inputEntry)
                }
                
                Section(header: Text("Actions")) {
                    
                    if model.shouldUpdatePrice {
                        Button(action: {self.fetchLastEquityLastChange()}, label: {Text("Last Change")})
                    }
                    
                    Button(action: {self.editAction()}) {Text(self.actionName)}
                    
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
        EquityDetail(model: Equity.preview).environmentObject(EquityViewModel())
    }
    
}
