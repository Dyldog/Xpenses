//
//  AccountsCoordinator.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 11/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import UIKit

protocol AccountsListCoordinatorType: class {
    func userDidRequestAddAccount()
    func userDidSelectAccount(account: Account)
}

protocol AddAccountCoordinatorType: class {
    func userDidFinishAddingAccount(accountDict: [String: Any?])
}

protocol TransactionListCoordinatorType: class {
    
}

class AccountsCoordinator {
    
    let navigationController: UINavigationController
    
    var coordinator: RootCoordinatorType!
    
    var accountsManager: AccountsManagerType! {
        didSet {
            updateAccountsList()
        }
    }
    
    
    lazy var accountsListViewController: AccountsListViewController = {
        let accountsListVC = AccountsListViewController()
        accountsListVC.title = "Accounts"
        accountsListVC.coordinator = self
        
        return accountsListVC
    }()
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    init() {
        navigationController = UINavigationController()
        navigationController.title = "Accounts"
        navigationController.viewControllers = [accountsListViewController]
    }
    
    func presentAddAccountViewController() {
        let addAccountVC = AddAccountViewController()
        addAccountVC.coordinator = self
        let navigationController = UINavigationController(rootViewController: addAccountVC)
        rootViewController.present(navigationController, animated: true)
    }
    
    func addAccount(fromDict dict: [String: Any?]) -> Bool {
        return accountsManager.addAccount(fromDict: dict)
    }
    
    func updateAccountsList() {
        accountsListViewController.accounts = accountsManager.allAccounts()
    }
    
    func presentAccountTransactionListViewController(for account: Account) {
        let transactionListVC = TransactionsListViewController()
        transactionListVC.title = account.name
        transactionListVC.transactions = account.transactions!.array as! [Transaction]
        (rootViewController as? UINavigationController)?.pushViewController(transactionListVC, animated: true)
    }
}

extension AccountsCoordinator: AccountsListCoordinatorType {
    
    func userDidRequestAddAccount() {
        self.presentAddAccountViewController()
    }
    
    func userDidSelectAccount(account: Account) {
        self.presentAccountTransactionListViewController(for: account)
    }
}

extension AccountsCoordinator: AddAccountCoordinatorType {
    func userDidFinishAddingAccount(accountDict: [String : Any?]) {
        let success = addAccount(fromDict: accountDict)
        
        if success, let addAccountNavController = rootViewController.presentedViewController as? UINavigationController, addAccountNavController.topViewController is AddAccountViewController {
            
            updateAccountsList()
            addAccountNavController.dismiss(animated: true)
        }
    }
}

extension AccountsCoordinator: TransactionListCoordinatorType { }
