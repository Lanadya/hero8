//
//  SeatingPosition+CoreDataProperties.swift
//  HeroCoreData
//
//  Created for hero8 on 18.04.2025.
//
//

import Foundation
import CoreData

extension SeatingPosition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SeatingPosition> {
        return NSFetchRequest<SeatingPosition>(entityName: "SeatingPosition")
    }

    @NSManaged public var classId: UUID
    @NSManaged public var column: Int16
    @NSManaged public var id: UUID
    @NSManaged public var row: Int16
    @NSManaged public var studentId: UUID
    @NSManaged public var class_: Class?
    @NSManaged public var student: Student?

}
