//
//  StockViewModel.swift
//  Trading Companion
//
//  Created by owee on 12/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

final class StockViewModel : ObservableObject {
    
    private var webService      = AlphavantageWS()
    private var index           = Index.main
    
    @Published var equities : [Equity] = []
    
    private func updates(equities:[Equity]) {
        
        self.equities.update(elements: equities)
        AppDelegate.saveContext()
        
    }
    
    func fetchEquities() {

        let list = index.equitiesList.sorted(by: {$0.name < $1.name})
        
        self.equities.append(contentsOf: list)
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
                    DispatchQueue.main.async {
                        stock.updateInformation(data: reponse)
                        self.equities.update(element: stock)
                        try? AppDelegate.viewContext.save()
                    }

                default: break
                }
            }
        }
        
        self.timer?.fire()
    }
    
}
