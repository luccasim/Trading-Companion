//
//  EquityDetail.swift
//  Trading Companion
//
//  Created by owee on 30/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct EquityDetail: View {
    
    let model : Equity
    @State var entry : String = "120"
    
    var body: some View {
        
        VStack(alignment: .center){
            
            // Global Informations
            HStack(alignment: .top) {
                VStack {
                    Text("Symbol")
                    Text("Name")
                    Spacer()
                }
                Spacer()
                VStack {
                    Text("Cours")
                    Text("Support : \(model.label)")
                }
            }
            
            Spacer()
            
            // Indicateurs
            HStack {
                Text("Données")
                Text("Tendance")
                Text("MM20")
                Spacer()
                Text("Objectifs")
            }
            
            // Simulation
            HStack {
                Text("Entrée:")
                TextField("Entrée", text: $entry)
                Spacer()
            }
            
            // Actions
            HStack {
                Text("Enregistrer")
                Spacer()
                Text("Ordre")
            }
            
            Spacer()
        }
    }
    
}

struct EquityDetail_Previews: PreviewProvider {
    static var previews: some View {
        EquityDetail(model: Equity.preview)
    }
}


