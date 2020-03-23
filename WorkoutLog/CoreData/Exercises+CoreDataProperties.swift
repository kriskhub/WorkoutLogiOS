//
//  Exercises+CoreDataProperties.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 22.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//
//

import Foundation
import CoreData


extension Exercises {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercises> {
        return NSFetchRequest<Exercises>(entityName: "Exercises")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: Data?
    @NSManaged public var date: Date?
    @NSManaged public var rate: Int64
    @NSManaged public var active: Bool

}
