//
//  StockViewModel.swift
//  Trading Companion
//
//  Created by owee on 12/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

final class StockViewModel : ObservableObject {
    
    private var stockManager    = StockManager.shared
    private var webService      = AlphavantageService()
    private var stockList       = SRDStocksData.list
    
    @Published var stocks : [Stock] = []
    
    func addStock(Stock:Stock) {
        self.stockManager.add(Stock: Stock)
        self.stocks.append(Stock)
    }
    
    private func fetchToDownload() -> [String] {
        
        self.stockManager.retrive()
        
        let localStock = self.stockManager.stocks.map({$0.symbol})
        let validStock = self.stockList
        
        let removeStock = localStock.filter {!validStock.contains($0)}
        
        if !removeStock.isEmpty {
            self.stockManager.remove(Symbols: removeStock)
        }
        
        self.stocks = self.stockManager.stocks
        
        return validStock.filter {!localStock.contains($0)}
    }
    
    func fetchStocks() {
        
        self.stockManager.retrive()
        self.stocks = self.stockManager.stocks
        self.stockManager.save()
        
    }
    
}
