//
//  Models.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 11/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import Foundation
import EventKit

//struct Transaction {
//    let description: String
//    let amount: Double
//}

//struct Account {
//    let name: String
//    let transactions: [Transaction]
//    
//    var balance: Double {
//        return transactions.map({ $0.amount }).reduce(0, { $0 + $1 })
//    }
//}

extension Account {
    var balance: Double {
        return transactions!.array.map({ ($0 as! Transaction).amount }).reduce(0, { $0 + $1 })
    }
}

enum Duration {
    case days(Int)
    case weeks(Int)
    case months(Int)
}

extension DateComponents {
    init(unit: TemporalUnit, multiple: Int) {
        switch unit {
        case .day: self = multiple.days
        case .week: self = multiple.weeks
        case .month: self = multiple.months
        }
    }
}

extension Duration {
    init(unit: TemporalUnit, multiple: Int) {
        switch unit {
        case .day: self = .days(multiple)
        case .week: self = .weeks(multiple)
        case .month: self = .months(multiple)
        }
    }
}

import RRuleSwift

extension RecurrenceFrequency {
    init(unit: TemporalUnit) {
        switch unit {
        case .day: self = .daily
        case .week: self = .weekly
        case .month: self = .monthly
        }
    }
}

extension BudgetTemplate {
    var date: Date? {
        get {
            return nsDate as Date?
        }
        
        set(value) {
            nsDate = value as! NSDate
        }
    }
}

extension BudgetInstance {
    var date: Date? {
        get {
            return nsDate as Date?
        }
        
        set(value) {
            nsDate = value as! NSDate
        }
    }
}

extension EKWeekday {
    static let allDays: [EKWeekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
}

//struct BudgetTemplate {
//    let description: String
//    let amount: Double
//    let date: Date
//    let recurrenceRuleString: String?
//}

//struct BudgetInstance {
//    let template: BudgetTemplate
//    let date: Date
//    let transaction: Transaction?
//}

