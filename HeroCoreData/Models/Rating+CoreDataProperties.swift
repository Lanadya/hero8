//
//  Rating+CoreDataProperties.swift
//  HeroCoreData
//
//  Created for hero8 on 18.04.2025.
//
//

import Foundation
import CoreData

extension Rating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rating> {
        return NSFetchRequest<Rating>(entityName: "Rating")
    }

    @NSManaged public var category: String?
    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var note: String?
    @NSManaged public var studentId: UUID
    @NSManaged public var value: Int16
    @NSManaged public var student: Student?

}
