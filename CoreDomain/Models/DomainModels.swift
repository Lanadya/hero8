//
//  DomainModels.swift
//  CoreDomain
//
//  Created for hero8 on 18.04.2025.
//

import Foundation

// MARK: - Class Model

/// Domänenmodell für eine Klasse
public struct ClassModel: Identifiable, Hashable {
    public let id: UUID
    public var name: String
    public var weekday: Int
    public var hour: Int
    public var subject: String?
    public var room: String?
    public var notes: String?
    public var isArchived: Bool
    
    public init(
        id: UUID = UUID(),
        name: String,
        weekday: Int,
        hour: Int,
        subject: String? = nil,
        room: String? = nil,
        notes: String? = nil,
        isArchived: Bool = false
    ) {
        self.id = id
        self.name = name
        self.weekday = weekday
        self.hour = hour
        self.subject = subject
        self.room = room
        self.notes = notes
        self.isArchived = isArchived
    }
    
    public var weekdayName: String {
        let weekdays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"]
        guard weekday >= 0 && weekday < weekdays.count else { return "" }
        return weekdays[weekday]
    }
}

// MARK: - Student Model

/// Domänenmodell für einen Schüler
public struct StudentModel: Identifiable, Hashable {
    public let id: UUID
    public var firstName: String
    public var lastName: String
    public var birthDate: Date?
    public var notes: String?
    public var classId: UUID?
    public var isArchived: Bool
    
    public init(
        id: UUID = UUID(),
        firstName: String,
        lastName: String,
        birthDate: Date? = nil,
        notes: String? = nil,
        classId: UUID? = nil,
        isArchived: Bool = false
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.notes = notes
        self.classId = classId
        self.isArchived = isArchived
    }
    
    public var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

// MARK: - Rating Model

/// Domänenmodell für eine Bewertung
public struct RatingModel: Identifiable, Hashable {
    public let id: UUID
    public var studentId: UUID
    public var value: Int
    public var note: String?
    public var date: Date
    public var category: String?
    
    public init(
        id: UUID = UUID(),
        studentId: UUID,
        value: Int,
        note: String? = nil,
        date: Date = Date(),
        category: String? = nil
    ) {
        self.id = id
        self.studentId = studentId
        self.value = value
        self.note = note
        self.date = date
        self.category = category
    }
}

// MARK: - Seating Position Model

/// Domänenmodell für eine Sitzposition
public struct SeatingPositionModel: Identifiable, Hashable {
    public let id: UUID
    public var studentId: UUID
    public var classId: UUID
    public var row: Int
    public var column: Int
    
    public init(
        id: UUID = UUID(),
        studentId: UUID,
        classId: UUID,
        row: Int,
        column: Int
    ) {
        self.id = id
        self.studentId = studentId
        self.classId = classId
        self.row = row
        self.column = column
    }
}
