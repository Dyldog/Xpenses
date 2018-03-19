//
//  TransactionsListViewController.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 11/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import UIKit

class TransactionsListViewController: UITableViewController {
    var coordinator: TransactionListCoordinatorType!
    
    var transactions: [Transaction] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reusableCell(style: .subtitle)
        
        let transaction = transactions[indexPath.row]
        
        cell.textLabel?.text = "\(transaction.amount)"
        cell.detailTextLabel?.text = transaction.description
        
        return cell
    }
}
