//
//  AccountsManager.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 11/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import Foundation
import MagicalRecord

protocol AccountsManagerType {
    func addAccount(fromDict dict: [String: Any?]) -> Bool
    func allAccounts() -> [Account]
}

class AccountsManager: AccountsManagerType {
    
    func allAccounts() -> [Account] {
        return Account.mr_findAll() as! [Account]
    }
    
    func addAccount(fromDict dict: [String : Any?]) -> Bool {
        guard let accountName = dict["name"] as? String else { return false } // TODO: Error
        guard let accountInitialBalance = dict["initialBalance"] as? Double else { return false } // TODO: Error
        
        let initialBalanceTransaction = Transaction.mr_createEntity()
        initialBalanceTransaction?.transactionDescription = "Initial balance"
        initialBalanceTransaction?.amount = accountInitialBalance
        
        let newAccount = Account.mr_createEntity()
        newAccount?.name = accountName
        newAccount?.transactions? = [initialBalanceTransaction!]
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()

        return true
    }
}
