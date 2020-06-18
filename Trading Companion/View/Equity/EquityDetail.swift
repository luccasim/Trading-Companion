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
    
    @EnvironmentObject var viewModel : EquityManager
    
    var model : Equity
    
    @State var worker   : Worker = Worker()
    @State var indic    = 0
    
    var dayCount : String {
        return self.indic == 0 ? "0" : "-\(self.indic)"
    }
        
    var body: some View {
                        
            Form {
                
                if self.worker.days.count > 0 {
                    
                    Section(header: Text("Echelle")) {
                        
                        if self.worker.couldUpdate {
                            Button("Update") {
                                self.worker.updateIndicator()
                            }
                        }
                        
                        Picker(selection: self.$indic, label: Text("Day \(self.dayCount)")) {
                            ForEach(self.model.allDays.indices) {
                                Text("\(self.worker.days[$0].dayDate)")
                            }
                        }.navigationBarTitle("\(model.name)")
                    }
                }
                
                Section(header: Text("Informations")) {
                    
                    TextView(label: "Cours", value: self.worker.price)
                   
                    if !self.worker.variation.isEmpty {
                        TextView(label: "Variation", value: self.worker.variation)
                    }
                    
                    NumberFieldView(label: "Alerte", input: self.$worker.inputAlert, lock: self.worker.lock)
                    
                    if self.worker.shouldDisplayGap {
                        TextView(label: "Ecart", value: self.worker.gap)
                    }
                }
                
                Section(header: Text("Indicateurs")) {
                    
                    if self.worker.isEquity && !self.worker.indexGap.isEmpty {
                        TextView(label: "\(self.worker.indexName)", value: self.worker.indexGap)
                    }
                    
                    if self.worker.hasVolume {
                        TextView(label: "Volume", value: self.worker.volume)
                    }
                    
                    if self.worker.hasTrend {
                        TextView(label: "MM20", value: self.worker.trend)
                    }
                    
                    if self.worker.hasRSI {
                        TextView(label: "RSI", value: self.worker.rsi)
                    }
                }
            
                Section(header: Text("Simulations")) {
                    
                    SimulationView(lock: self.worker.lock, objectif: self.$worker.inputEntry)
                }
            }
            .navigationBarTitle("\(model.name)")
            .onAppear() {
                self.worker.set(Model: self.model, Manager: self.viewModel)
                self.worker.daySelector = self.indic
            }
            .onDisappear() {
                self.worker.save()
            }
    }
}

extension EquityDetail {
    
    struct Worker {
        
        private weak var manager    : EquityManager?
        private weak var model      : Equity?
        
        var variation       = ""
        var inputAlert      = ""
        var inputEntry      = ""
        var lock            = false
        
        var daySelector     = 0
        
        var shouldDisplayGap : Bool {
            return !self.inputAlert.isEmpty
        }
        
        var days : [Day]  = []
        
        var selectedDay : Day? {
            guard self.days.count > 0 else {return nil}
            return self.days[self.daySelector]
        }
        
        var selectedDayTitle : String {
            return self.selectedDay?.date?.toStringDay ?? ""
        }
        
        var couldUpdate : Bool {
            return (self.selectedDay?.shouldUpdate ?? true)
        }
        
        var price : String {
            return self.selectedDay?.price ?? ""
        }
        
        var gap : String {

            guard let spot = self.selectedDay?.close, let alert = Double(self.inputAlert) else {
                return ""
            }
            
            let dif = ((spot - alert) / alert) * 100
            return String(format: "%.3f%%", dif)
        }
        
        var indexName : String {
            return self.model?.indexName ?? ""
        }
        
        var indexGap : String {
            return self.model?.index?.variation ?? ""
        }
        
        var rsi : String {
            return self.selectedDay?.rsi.toStringDecimal ?? ""
        }
        
        var volume : String {
            return self.selectedDay?.volume.toStringInt ?? ""
        }
        
        var trend : String {
            return self.selectedDay?.mm20.toStringInt ?? ""
        }
        
        var isEquity : Bool {
            return !(self.model?.isIndex ?? true)
        }
        
        var hasVolume : Bool {
            return !(self.selectedDay?.volume == 0)
        }
        
        var hasTrend : Bool {
            return !(self.selectedDay?.mm20 == 0)
        }
        
        var hasRSI : Bool {
            return !(self.selectedDay?.rsi == 0)
        }
        
        mutating func updateIndicator() {
            if let model = self.model {
                self.manager?.fetchIndicator(Equity: model)
            }
        }
        
        mutating func set(Model:Equity,Manager:EquityManager) {
            self.model = Model
            self.manager = Manager
            self.reset()
        }
        
        mutating func reset() {
            
            if let model = self.model {
                self.inputAlert = model.alert == 0 ? "" : model.alert.toString
                self.inputEntry = model.entry == 0 ? "" : model.entry.toString
                self.variation  = model.change?.percentFormat ?? ""
                self.daySelector = model.indexDay
                self.days = model.allDays
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
            
            self.model?.selectedDay = self.selectedDay?.label
        }
    }
}

struct EquityDetail_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            NavigationView {
                EquityDetail(model: Equity.preview).environmentObject(EquityManager())
            }
            
//            NavigationView {
//                EquityDetail(model: Index.main).environmentObject(EquityViewModel())
//            }
        }
    }
}
