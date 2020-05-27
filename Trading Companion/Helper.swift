//
//  Helper.swift
//  Trading Companion
//
//  Created by owee on 26/05/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import Foundation

extension Array where Element:Equatable {
    
    mutating func update(element:Element) {
        if let index = self.firstIndex(where: {$0 == element}) {
            self.remove(at: index)
            self.insert(element, at: index)
        }
    }
    
    mutating func update(elements:[Element]) {
        elements.forEach({self.update(element: $0)})
    }
}