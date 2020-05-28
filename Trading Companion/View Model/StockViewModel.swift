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

        let list = index.equitiesList.sorted(by: {$0.label < $1.label})
        
        self.equities.append(contentsOf: list)
        
        list.forEach { (equity) in
            equity.setter = {
                equity.updateInformation(data: $0)
            }
        }
        
        let listToUpdate = list.filter({$0.shouldUpdateInformation})
        
        self.webService.update(Endpoint: .detail, EquitiesList: listToUpdate) { (result) in
            switch result {
            case .success(let reponse):
                DispatchQueue.main.async {
                    if let equities = reponse as? [Equity] {
                        self.updates(equities: equities)
                    }
                
                }
            case .failure(let error):       print(error.localizedDescription)
            }
        }
        
    }
}
