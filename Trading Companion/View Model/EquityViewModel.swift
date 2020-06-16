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
    private var updateWS                = AlphavantageWS()
    
    @Published var index                = Index.main
    @Published var equities : [Equity]  = []
    
    private var state                   = State.installation
    
    @Published var title                = ""
    
    private var listToUpdate            = [Equity]()
    private var updateCount             = 0
    
    init() {
        
        let listInstalled   = self.index.equitiesList.filter({!$0.shouldInit})
        
        self.state = listToUpdate.isEmpty ==  false ? .installation : .finish
        
        self.listToUpdate = self.index.equitiesList.filter({$0.shouldInit})
        
        self.equities.update(elements: listInstalled)
        self.equities.sort(by: {$0.name < $1.name})
        
        self.publishTitle()
        
        self.fetchEquities()
    }

    private enum State {
        case installation
        case checkIndex
        case getMarketChange
        case finish
    }
    
    private func publishTitle() {
        
        DispatchQueue.main.async {
            
            switch self.state {
            case .installation:
                self.title = "Install [\(self.equities.count)/\(self.index.equitiesList.count)]"
            case .checkIndex:
                self.title = "Fetch Index"
            case .getMarketChange :
                self.title = "Update [\(self.updateCount)]"
            case .finish:
                self.title = "Equities \(self.index.equitiesList.count)"
            }
        }
    }
        
    private func updates(result: Result<[AlphavantageWSModel], Error>) {
        
        DispatchQueue.main.async {
            
            switch result {
                
            case .success(let reponse):
                
                if let _ = reponse as? [Index] {
                    break
                }
                
                if let equities = reponse as? [Equity] {
                    
                    equities.forEach { (eq) in
                        eq.objectWillChange.send()
                        if self.equities.contains(eq) == false {
                            self.equities.append(eq)
                        }
                    }
                    
                    self.equities.sort(by: {$0.name < $1.name})
                    self.updateCount -= 1
                    AppDelegate.saveContext()
                }
                
            case .failure(let error):
                print("Error -> \(error.localizedDescription)")
            }
            
            self.publishTitle()
        }
    }
    
    /// Information -> Index -> Day changes -> Finish.
    func fetchEquities() {
        self.fetchEquitiesInformations()
    }
    
    /// Fetch information on uninstalled equity, once finish or not list to install, fetch the index change.
    private func fetchEquitiesInformations() {
        
        self.state = .installation
                
        self.webService.update(Endpoints: [.detail, .history], EquitiesList: self.listToUpdate) { (result) in
            switch result {
            case .failure(let error):
                if case AlphavantageWS.Errors.endOfUpdate = error {
                    self.fetchEquitiesIndexChange()
                }
            default: self.updates(result: result)
            }
        }
    }
    
    private func fetchEquitiesIndexChange() {
        
        self.state = .checkIndex
        
        guard self.index.shouldUpdatePrice else {
            self.fetchEquitiesDayChange()
            return
        }
        
        self.webService.update(Endpoints: [.global], EquitiesList: [self.index]) { (result) in
            switch result {
            case .failure(let error):
                if case AlphavantageWS.Errors.endOfUpdate = error {
                    self.fetchEquitiesDayChange()
                }
            default: self.updates(result: result)
            }
        }
    }
    
    private func fetchEquitiesDayChange() {
        
        self.state = .getMarketChange
        
//        guard self.index.marketIsClose else {
//            print("Not auto update, market is open!.")
//            self.fetchEquitiesFinish()
//            return
//        }
        
        self.listToUpdate = self.equities.filter({$0.shouldUpdatePrice})
        self.updateCount = self.listToUpdate.count
        
        self.webService.update(Endpoints: [.global], EquitiesList: self.listToUpdate) { (result) in
            switch result {
            case .failure(let error):
                if case AlphavantageWS.Errors.endOfUpdate = error {
                    self.fetchEquitiesFinish()
                }
            default: self.updates(result: result)
            }
        }
    }
    
    private func fetchEquitiesFinish() {
        
        self.state = .finish
        
        self.publishTitle()
    }
    
    func fetchChange(Equity:Equity) {
        
        self.webService.update(Endpoints: [.global], EquitiesList: [Equity]) { (result) in
            self.updates(result: result)
        }
    }
    
    func fetchIndicator(Equity:Equity) {
        self.updateWS.update(Endpoints: [.rsi,.mm], EquitiesList: [Equity]) { (result) in
            self.updates(result: result)
        }
    }
    
//    func fecthRSI(Equity:Equity) {
//        self.webService.update(Endpoints: [.rsi], EquitiesList: [Equity]) { (result) in
//            self.updates(result: result)
//        }
//    }
}
