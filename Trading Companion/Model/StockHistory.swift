//
//  StockHistory.swift
//  Trading Companion
//
//  Created by owee on 18/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

struct StockHistory : Codable {
    
    let meta    : StockHistory.Meta
    let days    : [StockHistory.Day]
    
}

extension StockHistory {
    
    struct Meta : Codable {
        let informations    : String
        let symbol          : String
        let lastRefreshed   : String
        let output          : String
        let timezone        : String
    }
    
    struct Day : Codable {
        let date            : Date
        let open            : Double
        let high            : Double
        let low             : Double
        let close           : Double
        let volume          : Double
    }
}

extension StockHistory {
    
    var close : Double {
        return self.days.sorted {$0.date > $01.date}.first?.close ?? 42
    }
    
}

extension StockHistory {
    
    enum Errors : Error {
        case jsonFormat
        case missingMetaData
        case missingTimesSeries
        case missingInformation
        case missingSymbol
        case missingLastRefresh
        case missingOutput
        case missingTimezone
        case missingDate
        case missingOpen
        case missingClose
        case missingLow
        case missingHigh
        case missingVolume
    }
    
}

extension StockHistory.Meta {
    
    init(FromJson:[String:Any]?) throws {
                
        guard let dict = FromJson else {
            throw StockHistory.Errors.jsonFormat
        }
        
        guard let information = dict["1. Information"] as? String else {
            throw StockHistory.Errors.missingInformation
        }
        
        guard let symbol = dict["2. Symbol"] as? String else {
            throw StockHistory.Errors.missingSymbol
        }
        
        guard let lastRefresh = dict["3. Last Refreshed"] as? String else {
            throw StockHistory.Errors.missingLastRefresh
        }
        
        guard let output = dict["4. Output Size"] as? String else {
            throw StockHistory.Errors.missingOutput
        }
        
        guard let timezone = dict["5. Time Zone"] as? String else {
            throw StockHistory.Errors.missingTimezone
        }
        
        self.informations = information
        self.symbol = symbol
        self.lastRefreshed = lastRefresh
        self.output = output
        self.timezone = timezone
    }
}

extension StockHistory.Day {
    
    init(FromJson:[String:Any]?) throws {
        
        guard let dict = FromJson else {
            throw StockHistory.Errors.jsonFormat
        }
                
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        
        guard let strDate = dict.first?.key, let values = dict[strDate] as? [String:Any], let date = formater.date(from: strDate) else {
            throw StockHistory.Errors.missingDate
        }
        
        guard let strOpen = values["1. open"] as? String, let open = Double(strOpen) else {
            throw StockHistory.Errors.missingOpen
        }
        
        guard let strHigh = values["2. high"] as? String, let high = Double(strHigh) else {
            throw StockHistory.Errors.missingHigh
        }
        
        guard let strLow = values["3. low"] as? String, let low = Double(strLow) else {
            throw StockHistory.Errors.missingLow
        }
        
        guard let strClose = values["4. close"] as? String, let close = Double(strClose) else {
            throw StockHistory.Errors.missingClose
        }
        
        guard let strVolume = values["5. volume"] as? String, let volume = Double(strVolume) else {
            throw StockHistory.Errors.missingVolume
        }
        
        self.date = date
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
    }
}

extension StockHistory {
    
    init(fromAlphavantage: Data) throws {
        
        let json = try JSONSerialization.jsonObject(with: fromAlphavantage, options: [])
        
        guard let dict = json as? [String:Any] else {
            throw StockHistory.Errors.jsonFormat
        }
        
        guard let metaData = dict["Meta Data"] as? [String:Any] else {
            throw StockHistory.Errors.missingMetaData
        }
        
        self.meta = try StockHistory.Meta(FromJson: metaData)
        
        guard let timesJson = dict["Time Series (Daily)"] as? [String:Any] else {
            throw StockHistory.Errors.missingTimesSeries
        }
        
        self.days = {
            
            var result : [StockHistory.Day] = []
            
            for elem in timesJson {
                if let day = try? StockHistory.Day(FromJson: [elem.key:elem.value]) {
                    result.append(day)
                }
            }
            
            return result
        }()
    }
}
