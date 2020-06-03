//
//  StockList.swift
//  Trading Companion
//
//  Created by owee on 12/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct EquityList: View {
    
    @EnvironmentObject var viewModel : StockViewModel
    
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(entity: Equity.entity(), sortDescriptors: [
//        NSSortDescriptor(keyPath: \Equity.symbol, ascending: true)
//    ]) var equities : FetchedResults<Equity>
        
    var body: some View {
        
        NavigationView {
            
            List {
                
                ForEach(self.viewModel.equities) { equity in
                    
                    NavigationLink(destination: EquityDetail(model: equity)) {
                        EquityRow(equity: equity)
                    }
                }
                
            }.onAppear {
                self.viewModel.fetchEquitiesInformations()
            }.navigationBarTitle("TCD Equities")
        }
    }
}

struct StockList_Previews: PreviewProvider {
    static var previews: some View {
        EquityList().environmentObject(StockViewModel())
    }
}
