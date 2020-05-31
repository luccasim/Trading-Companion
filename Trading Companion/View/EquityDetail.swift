//
//  EquityDetail.swift
//  Trading Companion
//
//  Created by owee on 30/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct EquityDetail: View {
    
    @State var model : Equity
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Information")) {
                    
                    HStack(alignment: .top) {
                        Text("Cours")
                        Spacer()
                        Text("\(model.close)")
                    }
                    
                    if model.history != nil {
                        HStack(alignment: .top) {
                            Text("Support")
                            Spacer()
                            Text("Name")
                        }
                    } else {
                        TextField("Support", text: $model.inputSupport)
                    }
                }
                
                Section(header: Text("Indicateur")) {
                    
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
                
                Section(header: Text("Simulation")) {
                    
                    TextField("test", text: $model.inputEntry)
                    
                    if !self.model.inputEntry.isEmpty {
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
                
                Section() {
                    Button(action: {
                        print("OK")
                    }) {
                        Text("Register")
                    }
                }
                
            }.navigationBarTitle("\(model.name)")
        }

    }
}

struct EquityDetail_Previews: PreviewProvider {
    static var previews: some View {
        EquityDetail(model: Equity.preview)
    }
}


