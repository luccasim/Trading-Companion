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
    
    func addStocks(Stocks:[Stock]) {
        self.stocks.append(contentsOf: Stocks)
        self.stockManager.add(Stocks: Stocks)
    }
    
    func reloadStock() {
        self.stocks = self.stockManager.stocks
    }
    
    func fetchStocks() {
        self.webService.fetchEquityList(List: self.stockList) { (result) in
            switch result {
            case .success(let stocks): DispatchQueue.main.async {self.addStocks(Stocks: stocks)}
            case .failure(let error):   print("Error -> \(error.localizedDescription)")
            }
        }
    }
    
}
