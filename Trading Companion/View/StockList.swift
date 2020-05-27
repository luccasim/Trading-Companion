//
//  StockList.swift
//  Trading Companion
//
//  Created by owee on 12/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

protocol EquityListView : Identifiable {
    var little  : String { get }
    var name    : String { get }
    var close   : String { get }
    var support : String { get }
}

struct StockList: View {
    
    @EnvironmentObject var viewModel : StockViewModel
        
    var body: some View {
        
        List {
            
            ForEach(self.viewModel.equities) { equity in
                StockCell(symbol: equity.little, name: equity.name, close: equity.close, support: equity.support)
            }
            
            }.onAppear {
            self.viewModel.fetchEquities()
        }
    }
}

struct StockList_Previews: PreviewProvider {
    static var previews: some View {
        StockList().environmentObject(StockViewModel())
    }
}
