//
//  Student+CoreDataProperties.swift
//  HeroCoreData
//
//  Created for hero8 on 18.04.2025.
//
//

import Foundation
import CoreData

extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var birthDate: Date?
    @NSManaged public var classId: UUID?
    @NSManaged public var firstName: String
    @NSManaged public var id: UUID
    @NSManaged public var isArchived: Bool
    @NSManaged public var lastName: String
    @NSManaged public var notes: String?
    @NSManaged public var class_: Class?
    @NSManaged public var ratings: Set<Rating>?
    @NSManaged public var seatingPosition: SeatingPosition?
    
    public var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    public var ratingsArray: [Rating] {
        let set = ratings ?? []
        return set.sorted { $0.date > $1.date }
    }
}

// MARK: Generated accessors for ratings
extension Student {

    @objc(addRatingsObject:)
    @NSManaged public func addToRatings(_ value: Rating)

    @objc(removeRatingsObject:)
    @NSManaged public func removeFromRatings(_ value: Rating)

    @objc(addRatings:)
    @NSManaged public func addToRatings(_ values: NSSet)

    @objc(removeRatings:)
    @NSManaged public func removeFromRatings(_ values: NSSet)

}
