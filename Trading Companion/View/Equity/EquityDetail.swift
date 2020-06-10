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
    
    @State private var worker   : Worker = Worker()
        
    func fetchLastEquityLastChange() {
        self.viewModel.fetchChange(Equity: self.model)
    }
    
    var body: some View {
                    
            Form {
                
                Section(header: Text("Indicateurs")) {
                    
                    if !self.model.isIndex {
//                        TextView(label:self.model.indexName , value: self.model.indexGap)
                    }
                    
                    DoubleTextView(label: "Tendance", value: 0)
                    
                    DoubleTextView(label: "MM20", value: 0)
                    
                    if !self.model.isIndex {
                        TextView(label: "RSI", value: self.model.lastRSI)
                    }
                }
                
                Section(header: Text("Informations")) {
                    
                    TextView(label: "Cours", value: self.worker.price)
                    
                    TextView(label: "Variation", value: self.worker.variation)
                    
                    NumberFieldView(label: "Alerte", input: self.$worker.inputAlert, lock: self.worker.lock)
                    
                    if self.worker.shouldDisplayGap {
                        TextView(label: "Ecart", value: self.worker.gap)
                    }
                }
                
                Section(header: Text("Simulations")) {
                    
                    SimulationView(lock: self.worker.lock, objectif: self.$worker.inputEntry)
                }
            }
            .navigationBarTitle("\(model.name)")
            .onAppear() {
                self.worker.set(Model: self.model)
            }
            .onDisappear() {
                self.worker.save()
            }
    }
}

extension EquityDetail {
    
    struct Worker {
        
        private weak var model : Equity?
        
        var price           = ""
        var variation       = ""
        var inputAlert      = ""
        var inputEntry      = ""
        var lock            = false
        
        var shouldDisplayGap : Bool {
            return !self.inputAlert.isEmpty
        }
        
        var gap : String {

            guard let spot = self.model?.change?.price, let alert = Double(self.inputAlert) else {
                return ""
            }
            
            let dif = ((spot - alert) / alert) * 100
            return String(format: "%.3f%%", dif)
        }
        
        mutating func set(Model:Equity) {
            self.model = Model
            self.reset()
        }
        
        mutating func reset() {
            if let model = self.model {
                self.inputAlert = model.alert == 0 ? "" : model.alert.toString
                self.inputEntry = model.entry == 0 ? "" : model.entry.toString
                self.price      = model.change?.price.toString ?? ""
                self.variation  = model.change?.percentFormat ?? ""
            }
        }
        
        func save() {
            
            if let value = Double(self.inputAlert) {
                self.model?.alert = value
                print("Support saved")
            }
            
            if let value = Double(self.inputEntry) {
                self.model?.entry = value
                print("Objectif saved")
            }
        }
        
    }
}

struct EquityDetail_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            NavigationView {
                EquityDetail(model: Equity.preview).environmentObject(EquityViewModel())
            }
            
            NavigationView {
                EquityDetail(model: Index.main).environmentObject(EquityViewModel())
            }
        }
    }
}
