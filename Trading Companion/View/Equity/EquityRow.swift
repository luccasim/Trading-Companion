//
//  StockCell.swift
//  Trading Companion
//
//  Created by owee on 12/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct EquityRow: View {

    @ObservedObject var equity : Equity
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                Text(self.equity.little)
                    .font(.largeTitle)
                    .frame(height: nil)
                if !self.equity.name.isEmpty {
                    Text(self.equity.name)
                        .lineLimit(1)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2.0) {
                Text(self.equity.close).bold()
                Text(self.equity.variation)
            }
            
        }
        .padding(10.0)
        .layoutPriority(300)
    }
    
}

struct StockCell_Previews: PreviewProvider {
    
    static var previews: some View {
        List {
            
            EquityRow(equity: Index.main)
            
            EquityRow(equity: Equity.preview)
            
        }
    }
    
}
