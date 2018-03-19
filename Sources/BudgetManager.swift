//
//  BudgetManager.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 11/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import Foundation
import SwiftDate
import EventKit
import RRuleSwift
import MagicalRecord

protocol BudgetManagerType: class {
    func addBudgetTemplate(fromDict dict: [String: Any?]) -> Bool
    func allBudgetInstances() -> [BudgetInstance]
}

// TODO: Find better solution

extension Int {
    func times(_ loop: (Int) -> ()) {
        guard self > 0 else { return }
        for i in 0..<self {
            loop(i)
        }
    }
}



// TODO: Delete

extension RecurrenceRule {
    static func every(_ interval: Int) -> (days: ()->(RecurrenceRule), weeks: ()->(RecurrenceRule)) {
        var rule = RecurrenceRule(frequency: .daily)
        rule.interval = interval
        return (days: { rule.frequency = .daily; return rule }, weeks: { rule.frequency = .weekly; return rule })
    }
}

class BudgetManager: BudgetManagerType {
    
    private var budgetTemplates: [BudgetTemplate] {
        return BudgetTemplate.mr_findAll() as! [BudgetTemplate]
    }
    
    init() {
        addBudgetInstances(upToDate: 2.weeks.fromNow()!)
    }
    
    func addBudgetTemplate(fromDict dict: [String : Any?]) -> Bool {
        guard let description = dict["description"] as? String,
            let amount = dict["amount"] as? Double,
            let date = dict["date"] as? Date,
            let repeats = dict["repeats"] as? Bool else { return false }
        
        var rrule: RecurrenceRule? = nil
        
        if repeats {
            rrule = RecurrenceRule(frequency: .daily)
            rrule!.startDate = date
            
            guard let repeatStyle = dict["repeatStyle"] as? RepeatStyle else { return false }
            
            switch repeatStyle {
            case .periodically:
                guard let frequencyMultiple = dict["frequencyMultiple"] as? Int,
                    let frequencyUnit = dict["frequencyUnit"] as? TemporalUnit else { return false }
                
                rrule?.frequency = RecurrenceFrequency(unit: frequencyUnit)
                rrule?.interval = frequencyMultiple
            case .onDays:
                rrule?.byweekday = EKWeekday.allDays.filter({ (dict["repeats\($0.description.capitalized)"] as? Bool) ?? false })
                
            }
        }
        
        let template = BudgetTemplate.mr_createEntity()!
        template.expenseDescription = description
        template.amount = amount
        template.date = date
        template.reccurrenceRuleString = rrule?.toRRuleString()
        
        addBudgetInstances(upToDate: 2.weeks.fromNow()!)
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        
        return true
    }
    
    func addBudgetInstances(upToDate maxDate: Date) {
        for template in budgetTemplates {
            var instanceDates: [Date] = [template.date!]
            
            if let recurrenceRuleString = template.reccurrenceRuleString,
                let recurrenceRule = RecurrenceRule(rruleString: recurrenceRuleString) {
                
                instanceDates = recurrenceRule.occurrences(between: Date().startOfDay, and: maxDate.endOfDay)
            }
            let existingDates = template.instances!.flatMap({ ($0 as! BudgetInstance).date?.startOfDay })
            
            
            instanceDates.filter({ return !existingDates.contains($0.startOfDay) }).forEach({ date in
                let inst = BudgetInstance.mr_createEntity()
                inst?.template = template
                inst?.date = date
                
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            })
        }
    }
    
    func allBudgetInstances() -> [BudgetInstance] {
        return BudgetInstance.mr_findAll() as! [BudgetInstance]
    }
    
}
