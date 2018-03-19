//
//  AddBudgetViewController.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 11/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import UIKit
import Eureka
import EventKit

enum TemporalUnit {
    case day
    case week
    case month
}

extension TemporalUnit: CustomStringConvertible {
    var description: String {
        switch self {
        case .day: return "day"
        case .week: return "week"
        case .month: return "month"
        }
    }
}

enum RepeatStyle {
    case periodically
    case onDays
}

extension RepeatStyle: CustomStringConvertible {
    var description: String {
        switch self {
        case .periodically: return "Periodically"
        case .onDays: return "On days"
        }
    }
}

extension EKWeekday: CustomStringConvertible {
    public var description: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
}

class AddBudgetViewController: FormViewController {
    var coordinator: AddBudgetCoordinatorType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
            <<< TextRow() { row in
                row.title = "Description"
                row.tag = "description"
                row.add(rule: RuleRequired())
            }
            <<< DecimalRow() { row in
                row.title = "Amount"
                row.tag = "amount"
                row.add(rule: RuleRequired())
            }
            <<< DateRow() { row in
                row.title = "Date"
                row.tag = "date"
                row.value = Date()
                row.add(rule: RuleRequired())
            }
        
        let repeatStyleHideCondition = Condition.function(["repeats"], { form in
            let repeatsHidden = !(form.rowBy(tag: "repeats") as? SwitchRow)!.value!
            return repeatsHidden
        })
        
        let periodicalRepeatRowHideCondition = Condition.function(["repeats", "repeatStyle"], { form in
            let repeatsHidden = !(form.rowBy(tag: "repeats") as? SwitchRow)!.value!
            let repeatsNotPeriodical = (form.rowBy(tag: "repeatStyle") as? SegmentedRow<RepeatStyle>)!.value! != RepeatStyle.periodically
            
            return repeatsHidden || repeatsNotPeriodical
        })
        
        let onDaysRepeatRowHideCondition = Condition.function(["repeats", "repeatStyle"], { form in
            let repeatsHidden = !(form.rowBy(tag: "repeats") as? SwitchRow)!.value!
            let repeatsNotOnDays = (form.rowBy(tag: "repeatStyle") as? SegmentedRow<RepeatStyle>)!.value != RepeatStyle.onDays
            
            return repeatsHidden || repeatsNotOnDays
        })
        form +++ Section()
            <<< SwitchRow() { row in
                row.title = "Repeats"
                row.tag = "repeats"
                row.value = false
                row.add(rule: RuleRequired(msg: "Repeats"))
            }
            <<< SegmentedRow<RepeatStyle>() { row in
                row.tag = "repeatStyle"
                row.options = [.periodically, .onDays]
                row.value = .periodically
                row.hidden = repeatStyleHideCondition
                row.add(rule: RuleRequired(msg: "Repeat style"))
            }
            <<< IntRow() { row in
                row.title = "Every"
                row.tag = "frequencyMultiple"
                row.hidden = periodicalRepeatRowHideCondition
                row.add(rule: RuleRequired(msg: "Frequency multiple"))
            }
            <<< SegmentedRow<TemporalUnit>() { row in
                row.tag = "frequencyUnit"
                row.options = [.day, .week, .month]
                row.hidden = periodicalRepeatRowHideCondition
                row.add(rule: RuleRequired(msg: "Frequency unit"))
            }
            
            EKWeekday.allDays.forEach({ day in
                form.last! <<< CheckRow() { row in
                    row.title = "\(day)"
                    row.tag = "repeats\(day.description.capitalized)"
                    row.hidden = onDaysRepeatRowHideCondition
                    row.add(rule: RuleClosure(closure: { _ in
                        return EKWeekday.allDays.map({ "repeats\($0.description.capitalized)" })
                            .map({ self.form.rowBy(tag: $0) as? CheckRow })
                            .map({ $0?.value ?? false })
                            .reduce(false, { $0 || $1 })
                            ? nil : ValidationError(msg: "Must select at least one day")
                    }))
                }
            })
        
        form +++ Section()
            <<< ButtonRow() { button in
                button.title = "Done"
                button.onCellSelection({ _,_ in
                    self.doneButtonTapped()
                })
        }
    }
    
    func doneButtonTapped() {
        if form.validate().count == 0 {
            coordinator.userDidFinishAddingBudget(budgetDict: form.values())
        }
    }
}
