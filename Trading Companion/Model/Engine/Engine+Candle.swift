//
//  Engine+Model.swift
//  Trading Companion
//
//  Created by owee on 18/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

extension Engine {
    
    struct Candle : CustomStringConvertible {
        
        let high    : Double
        let low     : Double
        let open    : Double
        let close   : Double
        let date    : Date
        
        init?(Day:Day) {
  
            guard let date  = Day.date else {
                print("Day :\(Day.label) has no date, can't create the candle.")
                return nil
            }
            
            self.high   = Day.high
            self.low    = Day.low
            self.open   = Day.open
            self.close  = Day.close
            self.date   = date
            
        }
        
        var color : Color {
            
            let closing = close - open
            
            if closing > 0 {
                return .green
            }
        
            else if closing < 0{
                return .red
            }
            
            return .none
        }
        
        enum Color {
            case red, green, none
        }
        
        enum State {
            case support, resistance, normal
        }
        
        var description : String {
            return "\(self.date.toStringDay) [\(self.color)]"
        }
        
    }
    
    func getCandles(Days:[Day]) -> [Candle] {
        let candles = Days.compactMap({Candle(Day: $0)})
        return candles.sorted(by: {$0.date > $1.date})
    }
    
    
    
//    func searchSupport(LastDay:Int, Candle:[Candle]) -> [Candle] {
//        
//        var i = 0
//        
//        while (i < LastDay) {
//            
//            i += 1
//        }
//    }
    
    
}
