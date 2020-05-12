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
    }
    
    func reloadStock() {
        self.stocks = self.stockManager.stocks
    }
    
    func fetchStocks() {
        self.webService.taskEquityDailyTime(StockName: "AC.PA") { (result) in
            switch result {
            case .success(let stock): self.addStock(Stock: stock)
            case .failure(let error): print("Error -> \(error.localizedDescription)")
            }
        }
    }
    
}
