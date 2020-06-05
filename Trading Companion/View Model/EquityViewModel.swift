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
    
    init() {
        self.equities.append(contentsOf: self.sortedList)
    }
    
    var count : Int {
        return self.equities.count
    }
    
    func updates(result: Result<[AlphavantageWSModel], Error>) {
        
        switch result {
        case .success(let reponse):
            if let equities = reponse as? [Equity] {
                DispatchQueue.main.async {
                    self.equities.update(elements: equities)
                    AppDelegate.saveContext()
                }
            }
        case .failure(let error):
            print("Error -> \(error.localizedDescription)")
        }
    }
    
    private lazy var sortedList = {
        self.index.equitiesList.sorted(by: {$0.label < $1.label})
    }()
    
    func fetchEquitiesInformations() {
        
        //Init
        let listToUpdate = self.sortedList.filter({$0.shouldInit})
        
        guard listToUpdate.count > 1 else {
            self.fetchEquitiesChange()
            return
        }
        
        self.webService.update(Endpoint: .detail, EquitiesList: listToUpdate) { (result) in
            self.updates(result: result)
        }
    }
    
    func fetchEquitiesChange() {
        
        let list = self.sortedList.filter({$0.shouldUpdatePrice})
        
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
