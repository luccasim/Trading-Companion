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
    
    func updates(equities:[Equity]) {
        DispatchQueue.main.async {
        self.equities.update(elements: equities)
        }
    }
    
    private lazy var sortedList = {
        self.index.equitiesList.sorted(by: {$0.label < $1.label})
    }()
    
    func fetchEquitiesInformations() {
        
        self.equities.append(contentsOf: self.sortedList)
        
        let listToUpdate = self.sortedList.filter({$0.shouldUpdateInformation})
        
        self.webService.update(Endpoint: .detail, EquitiesList: listToUpdate) { (result) in
            switch result {
            case .success(let reponse):
                if let equities = reponse as? [Equity] {
                    self.updates(equities: equities)
                }
            case .failure(let error):
                if case AlphavantageWS.Errors.endOfUpdate = error {
                    self.fetchEquitiesChange()
                }
            }
        }
    }
    
    func fetchEquitiesChange() {
        
        let list = self.sortedList.filter({$0.shouldUpdateChange})
        
        self.webService.update(Endpoint: .global, EquitiesList: list) { (result) in
            switch result {
            case .success(let reponse):
                if let equity = reponse as? [Equity] {
                    self.updates(equities: equity)
                }
            case .failure(_): break
            }
        }
    }
}
