//
//  Date+Extensions.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 12/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import Foundation
import SwiftDate

func *(lhs: Int, rhs: DateComponents) -> DateComponents {
    var comps = rhs
    
    (lhs - 1).times { _ in
        comps = comps + rhs
    }
    
    return comps
}

extension Date {
    func dateRange(to toDate: Date, step: DateComponents) -> [Date] {
        let fromDate = self
            
        guard fromDate < toDate else { return [] }
        
        var dates: [Date] = [fromDate]
        
        while true {
            let nextDate = fromDate + (dates.count * step)
            
            if nextDate < toDate {
                dates.append(nextDate)
            } else {
                return dates
            }
        }
        
    }
}
