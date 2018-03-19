//
//  AddAccountViewController.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 11/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import UIKit
import Eureka

class AddAccountViewController: FormViewController {
    var coordinator: AddAccountCoordinatorType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New Account"
        
        form +++ Section()
            <<< TextRow() { row in
                row.title = "Name"
                row.tag = "name"
                row.validationOptions = .validatesOnChange
                row.add(rule: RuleRequired())
            }
            <<< DecimalRow() { row in
                row.title = "Initial Balance"
                row.tag = "initialBalance"
                row.validationOptions = .validatesOnChange
                row.add(rule: RuleRequired())
            }
        
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
            coordinator.userDidFinishAddingAccount(accountDict: form.values())
        }
    }
    
}
