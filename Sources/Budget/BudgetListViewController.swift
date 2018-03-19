//
//  BudgetListViewController.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 11/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import UIKit

class BudgetListViewController: UITableViewController {
    weak var coordinator: BudgetListCoordinatorType!
    
    var budgetInstances: [BudgetInstance] = [] {
        didSet {
            let groupedInstances: [Date: [BudgetInstance]] = Dictionary(grouping: budgetInstances, by: {
                $0.date!.startOfDay
            })
            
            sections = groupedInstances.keys.map { ($0, groupedInstances[$0]!) }.sorted(by: { $0.date < $1.date })
        }
    }
    
    typealias Section = (date: Date, budgetInstances: [BudgetInstance])
    var sections: [Section] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    @objc func addButtonTapped() {
        coordinator.userDidRequestAddBudget()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let distString: String = {
            let dayDistance = Date().startOfDay.component(.day, to: sections[section].date)!
            switch dayDistance {
            case ...(-2): return "\(dayDistance) days ago"
            case -1: return "1 day ago"
            case 0: return "Today"
            case 1: return "In 1 day"
            case 2...: return "in \(dayDistance) days"
            default:
                fatalError()
            }
        }()
        
        return "\(distString) \(sections[section].date.string(format: .custom("dd/MM")))"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].budgetInstances.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reusableCell(style: .subtitle)
        
        let budgetInstance = sections[indexPath.section].budgetInstances[indexPath.row]
        
        cell.textLabel?.text = budgetInstance.template!.expenseDescription
        cell.detailTextLabel?.text = "$\(budgetInstance.template!.amount)"
        
        return cell
    }
}
