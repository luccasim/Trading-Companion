//
//  Engine+Mock.swift
//  Trading CompanionTests
//
//  Created by owee on 18/06/2020.
//  Copyright © 2020 devios. All rights reserved.
//

import XCTest
@testable import Trading_Companion

class Engine_Mock {
    
    let days : [Day]

    init() {
        let eq = Equity.preview
        self.days = eq.allDays
    }

}
