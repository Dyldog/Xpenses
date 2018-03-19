//
//  ViewController.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 11/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import UIKit

class AccountsListViewController: UITableViewController {
    weak var coordinator: AccountsListCoordinatorType!
    
    var accounts: [Account] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Accounts"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    @objc func addBarButtonTapped() {
        coordinator.userDidRequestAddAccount()
    }

    func reloadData() {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reusableCell(style: .value2)
        
        let account = accounts[indexPath.row]
        
        cell.textLabel?.text = account.name
        cell.detailTextLabel?.text = "\(account.balance)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = accounts[indexPath.row]
        coordinator.userDidSelectAccount(account: account)
    }

}

