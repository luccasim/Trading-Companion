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
    private var webService      = AlphavantageWS()
    private var stockList       = EquitiesGroup.SRD.list
    private var index           = Index.main
    
    @Published var stocks : [Equity] = []
    
//    func addStock(Stock:Stock) {
//
//        self.stockManager.update(Stock: Stock)
//        if let index = self.stocks.firstIndex(where: {$0.symbol == Stock.symbol}) {
//            self.stocks[index] = Stock
//        }
//    }
//
//    private func fetchToDownload() -> [String] {
//
//        self.stockManager.retrive()
//
//        let localStock = self.stockManager.stocks.map({$0.symbol})
//        let validStock = self.stockList
//
//        let removeStock = localStock.filter {!validStock.contains($0)}
//
//        if !removeStock.isEmpty {
//            self.stockManager.remove(Symbols: removeStock)
//        }
//
//        self.stocks = self.stockManager.stocks
//
//        return validStock.filter {!localStock.contains($0)}
//    }
    
    func fetchStocks() {
        
//        self.stockManager.retrive()
//        self.stocks = self.stockManager.stocks
//        self.stockManager.save()
//
        self.stocks.append(contentsOf: index.equitiesList)
        self.updateList = self.index.equitiesList.filter({$0.shouldUpdateInformation})
        
        self.updater()
    }
    
    private var timer : Timer?
    private var updateList : [Equity] = []
    
    func updater() {
                
        self.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { (timer) in
            
            guard self.updateList.isEmpty == false else {
                self.timer?.invalidate()
                return
            }
            
            let stock = self.updateList.removeFirst()
            
            self.webService.update(Equity: stock) { (result) in
                switch result {
                case .success(let reponse):
                    stock.updateInformation(json: reponse)
                    
                default: break
                }
            }
        }
        
        self.timer?.fire()
    }
    
}
