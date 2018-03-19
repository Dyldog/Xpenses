//
//  BudgetTemplate+CoreDataProperties.swift
//  Expenses
//
//  Created by ELLIOTT, Dylan on 12/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//
//

import Foundation
import CoreData


extension BudgetTemplate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BudgetTemplate> {
        return NSFetchRequest<BudgetTemplate>(entityName: "BudgetTemplate")
    }

    @NSManaged public var reccurrenceRuleString: String?
    @NSManaged public var expenseDescription: String?
    @NSManaged public var nsDate: NSDate?
    @NSManaged public var amount: Double
    @NSManaged public var instances: NSSet?

}

// MARK: Generated accessors for instances
extension BudgetTemplate {

    @objc(addInstancesObject:)
    @NSManaged public func addToInstances(_ value: BudgetInstance)

    @objc(removeInstancesObject:)
    @NSManaged public func removeFromInstances(_ value: BudgetInstance)

    @objc(addInstances:)
    @NSManaged public func addToInstances(_ values: NSSet)

    @objc(removeInstances:)
    @NSManaged public func removeFromInstances(_ values: NSSet)

}
