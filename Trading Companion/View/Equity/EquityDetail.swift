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
                        TextView(label:self.model.indexName , value: self.model.indexGap)
                    }
                    
                    DoubleTextView(label: "Tendance", value: 0)
                    
                    DoubleTextView(label: "MM20", value: 0)
                    
                    if !self.model.isIndex {
                        TextView(label: "RSI", value: self.model.lastRSI)
                    }
                }
                
                Section(header: Text("Informations")) {
                    
                    TextView(label: "Cours", value: model.close)
                    
                    TextView(label: "Variation", value: model.prevChangePercent)
                    
                    NumberFieldView(label: "Alerte", input: self.$worker.inputAlert, lock: self.worker.lock)
                    
                    if self.worker.shouldDisplayGap {
                        TextView(label: "Ecart", value: model.gap)
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
        
        private var model : Equity?
        
        var inputAlert      = ""
        var inputEntry      = ""
        var lock            = false
        
        var shouldDisplayGap : Bool {
            return !self.inputAlert.isEmpty
        }
        
        mutating func set(Model:Equity) {
            self.model = Model
            self.reset()
        }
        
        mutating func reset() {
            if let model = self.model {
                self.inputAlert = model.support == 0 ? "" : model.support.toString
                self.inputEntry = model.entry == 0 ? "" : model.support.toString
            }
        }
        
        func save() {
            
            if let value = Double(self.inputAlert) {
                self.model?.support = value
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
