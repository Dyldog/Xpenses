//
//  BudgetInstance+CoreDataProperties.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 12/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//
//

import Foundation
import CoreData


extension BudgetInstance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetInstance> {
        return NSFetchRequest<BudgetInstance>(entityName: "BudgetInstance")
    }

    @NSManaged public var nsDate: NSDate?
    @NSManaged public var notes: String?
    @NSManaged public var template: BudgetTemplate?
    @NSManaged public var transaction: Transaction?

}
