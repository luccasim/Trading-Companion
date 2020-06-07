//
//  StockViewModel.swift
//  Trading Companion
//
//  Created by owee on 12/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

final class EquityViewModel : ObservableObject {
    
    private var webService              = AlphavantageWS()
    
    @Published var index                = Index.main
    @Published var equities : [Equity]  = []
    
    var count : Int {
        return self.equities.count
    }
    
    var maxCount : Int {
        return self.index.equitiesList.count
    }
    
    init() {
        let listInstalled   = self.index.equitiesList.filter({!$0.shouldInit})
        
        self.equities.update(elements: listInstalled)
        self.equities.sort(by: {$0.name < $1.name})
    }
    
    func updates(result: Result<[AlphavantageWSModel], Error>) {
        
        switch result {
        case .success(let reponse):
            if let equities = reponse as? [Equity] {
                DispatchQueue.main.async {
                    self.equities.update(elements: equities)
                    self.equities.sort(by: {$0.name < $1.name})
                    AppDelegate.saveContext()
                }
            }
        case .failure(let error):
            print("Error -> \(error.localizedDescription)")
        }
    }
    
    func fetchEquitiesInformations() {
        
        let listToUpdate    = self.index.equitiesList.filter({$0.shouldInit})
        
        guard listToUpdate.count > 1 else {
            self.fetchEquitiesChange()
            return
        }
        
        self.webService.update(Endpoint: .detail, EquitiesList: listToUpdate) { (result) in
            self.updates(result: result)
        }
    }
    
    func fetchEquitiesChange() {
        
        let list = self.equities.filter({$0.shouldUpdatePrice})
        
        self.webService.update(Endpoint: .global, EquitiesList: list) { (result) in
            self.updates(result: result)
        }
    }
    
    func fetchChange(Equity:Equity) {
        
        self.webService.update(Endpoint: .global, EquitiesList: [Equity]) { (result) in
            self.updates(result: result)
        }
    }
}
