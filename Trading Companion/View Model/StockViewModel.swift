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
        self.stocks.append(Stock)
        self.stockManager.add(Stock: Stock)
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
        
        let list = self.fetchToDownload()
        
        guard !list.isEmpty else {
            return
        }
        
        self.webService.fetchEquityList(List: list) { (result) in
            switch result {
            case .success(let stock):   DispatchQueue.main.async {self.addStock(Stock: stock)}
            case .failure(let error):   print("Error -> \(error.localizedDescription)")
            }
        }
    }
    
}
