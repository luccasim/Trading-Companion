//
//  StockList.swift
//  Trading Companion
//
//  Created by owee on 12/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct StockList: View {
    
    @EnvironmentObject var viewModel : StockViewModel
        
    var body: some View {
        
        NavigationView {
            List {
                
                ForEach(self.viewModel.equities) { equity in
                    
                    NavigationLink(destination: EquityDetail(model: equity)) {
                        
                    StockCell(symbol: equity.little, name: equity.name, close: equity.close, support: equity.alert)
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
        StockList().environmentObject(StockViewModel())
    }
}
