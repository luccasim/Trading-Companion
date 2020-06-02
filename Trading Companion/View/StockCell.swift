//
//  StockCell.swift
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
    var alert   : String { get }
}

struct StockCell: View {
        
    var symbol  : String       = "ABC"
    var name    : String       = "Title"
    var close   : String       = "12"
    @State var support : String       = "10"
    
    func color() -> Color {
        guard let close = Double(self.close), let support = Double(self.support) else {
            return .black
        }
        return close < support ? .green : .primary
    }
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                Text(self.symbol)
                    .font(.largeTitle)
                    .frame(height: nil)
                Text(self.name)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(self.close)
                Text(self.support)
            }
            
        }
        .padding(10.0)
        .layoutPriority(300)
    }
    
}

struct StockCell_Previews: PreviewProvider {
    
    static var previews: some View {
        StockCell()
    }
    
}
