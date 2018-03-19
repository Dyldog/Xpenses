//
//  Transaction+CoreDataProperties.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 12/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var transactionDescription: String?

}
