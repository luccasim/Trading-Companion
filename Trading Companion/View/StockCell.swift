//
//  StockCell.swift
//  Trading Companion
//
//  Created by owee on 12/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import SwiftUI

struct StockCell: View {
    
    var name    : String = "Title"
    var close   : String = "12"
    var support : String = "10"
    
    var body: some View {
        
        HStack {
            
            Text(self.name)
                .font(.largeTitle)
            
            Spacer()
            VStack {
                Text(self.close)
                Text(self.support)
            }
        }
        .padding(10.0)
    }
    
}

struct StockCell_Previews: PreviewProvider {
    static var previews: some View {
        StockCell()
    }
}