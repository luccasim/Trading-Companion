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
    
    @State var model : Equity
    
    @State private var inputSupport : String = ""
    @State private var inputEntry   : String = ""
    
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
                        Text("Support")
                        if self.lock {
                            Spacer()
                            Text("\(model.support)")
                        } else {
                            TextField("0.0", text: $inputSupport).keyboardType(.numbersAndPunctuation).multilineTextAlignment(.trailing)
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
                    
                    TextField("test", text: $inputEntry)
                    
                    if !self.inputEntry.isEmpty {
                        Group {
                            
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
                self.model.register(InputSupport: self.inputSupport, InputEntry: self.inputEntry)
        }
    }
}

struct EquityDetail_Previews: PreviewProvider {
    static var previews: some View {
        EquityDetail(model: Equity.preview)
    }
}


