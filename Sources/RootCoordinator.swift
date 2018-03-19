//
//  RootCoordinator.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 11/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import UIKit

protocol RootCoordinatorType {
    
}

class RootCoordinator: RootCoordinatorType {
    //let navigationController: UINavigationController
    let tabBarController: UITabBarController
    
    let budgetCoordinator: BudgetCoordinator
    let budgetManager: BudgetManagerType
    
    var accountsManager: AccountsManagerType!
    let accountsCoordinator: AccountsCoordinator
    
    init(accountsManager: AccountsManagerType, budgetManager: BudgetManagerType) {
        
        tabBarController = UITabBarController()
        //navigationController = UINavigationController(rootViewController: tabBarController)
        
        self.accountsManager = accountsManager
        self.budgetManager = budgetManager
        
        budgetCoordinator = BudgetCoordinator()
        budgetCoordinator.budgetManager = self.budgetManager
        
        accountsCoordinator = AccountsCoordinator()
        accountsCoordinator.accountsManager = self.accountsManager
        
        budgetCoordinator.coordinator = self
        accountsCoordinator.coordinator = self
        
        tabBarController.viewControllers = [budgetCoordinator.rootViewController, accountsCoordinator.rootViewController]
        
    }
    
    var rootViewController: UIViewController {
        return tabBarController
    }
}
