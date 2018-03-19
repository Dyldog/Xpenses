//
//  AppDelegate.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 11/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import UIKit
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var accountsManager: AccountsManager!
    var budgetManager: BudgetManager!
    
    var rootCoordinator: RootCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        MagicalRecord.setupCoreDataStack()
        
        accountsManager = AccountsManager()
        budgetManager = BudgetManager()
        
        rootCoordinator = RootCoordinator(accountsManager: accountsManager, budgetManager: budgetManager)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = .white
            window.rootViewController = rootCoordinator.rootViewController
            window.makeKeyAndVisible()
        }
        
        return true
    }
}

