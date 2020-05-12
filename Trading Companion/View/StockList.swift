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
        
        List {
            
            ForEach(self.viewModel.stocks) { stock in
                StockCell(name: stock.symbol, close: stock.close, support: 10)
            }
            
            }.onAppear {
            self.viewModel.fetchStocks()
        }
    }
}

struct StockList_Previews: PreviewProvider {
    static var previews: some View {
        StockList().environmentObject(StockViewModel())
    }
}
