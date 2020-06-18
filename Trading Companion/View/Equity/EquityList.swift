//
//  StockList.swift
//  Trading Companion
//
//  Created by owee on 12/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct EquityList: View {
    
    @EnvironmentObject var viewModel : EquityManager
        
    var body: some View {
        
        NavigationView {
            
            List {

                NavigationLink(destination: EquityDetail(model: self.viewModel.index).environmentObject(self.viewModel)) {
                    EquityRow(equity: self.viewModel.index)
                }
                
                ForEach(self.viewModel.equities) { equity in
                    
                    NavigationLink(destination: EquityDetail(model: equity)) {
                        EquityRow(equity: equity)
                    }
                }
                
            }.navigationBarTitle(self.viewModel.title)
        }
    }
}

struct StockList_Previews: PreviewProvider {
    static var previews: some View {
        EquityList().environmentObject(EquityManager())
    }
}
