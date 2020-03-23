//
//  Sets+CoreDataProperties.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 22.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//
//

import Foundation
import CoreData


extension Sets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sets> {
        return NSFetchRequest<Sets>(entityName: "Sets")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var rate: Int64
    @NSManaged public var workout: Workout?
    @NSManaged public var exercise: Exercises?

}
