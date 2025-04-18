//
//  Class+CoreDataProperties.swift
//  HeroCoreData
//
//  Created for hero8 on 18.04.2025.
//
//

import Foundation
import CoreData

extension Class {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Class> {
        return NSFetchRequest<Class>(entityName: "Class")
    }

    @NSManaged public var hour: Int16
    @NSManaged public var id: UUID
    @NSManaged public var isArchived: Bool
    @NSManaged public var name: String
    @NSManaged public var notes: String?
    @NSManaged public var room: String?
    @NSManaged public var subject: String?
    @NSManaged public var weekday: Int16
    @NSManaged public var seatingPositions: Set<SeatingPosition>?
    @NSManaged public var students: Set<Student>?

    public var studentsArray: [Student] {
        let set = students ?? []
        return set.sorted { $0.lastName < $1.lastName }
    }
    
    public var seatingPositionsArray: [SeatingPosition] {
        let set = seatingPositions ?? []
        return Array(set)
    }
}

// MARK: Generated accessors for seatingPositions
extension Class {

    @objc(addSeatingPositionsObject:)
    @NSManaged public func addToSeatingPositions(_ value: SeatingPosition)

    @objc(removeSeatingPositionsObject:)
    @NSManaged public func removeFromSeatingPositions(_ value: SeatingPosition)

    @objc(addSeatingPositions:)
    @NSManaged public func addToSeatingPositions(_ values: NSSet)

    @objc(removeSeatingPositions:)
    @NSManaged public func removeFromSeatingPositions(_ values: NSSet)

}

// MARK: Generated accessors for students
extension Class {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}
