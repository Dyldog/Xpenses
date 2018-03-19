//
//  BudgetCoordinator.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 11/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import UIKit

protocol BudgetListCoordinatorType: class {
    func userDidRequestAddBudget()
}

protocol AddBudgetCoordinatorType: class {
    func userDidFinishAddingBudget(budgetDict: [String: Any?])
}

class BudgetCoordinator {
    
    var coordinator: RootCoordinatorType!
    var budgetManager: BudgetManagerType! {
        didSet {
            updateBudgetList()
        }
    }
    
    let navigationController: UINavigationController
    
    lazy var budgetListViewController: BudgetListViewController = {
        let budgetListVC = BudgetListViewController()
        budgetListVC.title = "Budgets"
        budgetListVC.coordinator = self
        
        return budgetListVC
    }()

    var rootViewController: UIViewController {
        return navigationController
    }
    
    init() {
        navigationController = UINavigationController()
        navigationController.title = "Budgets"
        navigationController.viewControllers = [budgetListViewController]
    }
    
    func updateBudgetList() {
        budgetListViewController.budgetInstances = budgetManager.allBudgetInstances().sorted(by: { $0.date! < $1.date! })
    }
}

extension BudgetCoordinator: BudgetListCoordinatorType {
    func userDidRequestAddBudget() {
        let addBudgetVC = AddBudgetViewController()
        addBudgetVC.coordinator = self
        let navigationController = UINavigationController(rootViewController: addBudgetVC)
        rootViewController.present(navigationController, animated: true)
    }
}

extension BudgetCoordinator: AddBudgetCoordinatorType {
    func userDidFinishAddingBudget(budgetDict: [String: Any?]) {
        let success = budgetManager.addBudgetTemplate(fromDict: budgetDict)
        
        if success, let addBudgetNavController = rootViewController.presentedViewController as? UINavigationController, addBudgetNavController.topViewController is AddBudgetViewController {
            
            updateBudgetList()
            addBudgetNavController.dismiss(animated: true)
        }
    }
    
    
}
