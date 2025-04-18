//
//  CoreDataStudentRepository.swift
//  CoreInfrastructure
//
//  Created for hero8 on 18.04.2025.
//

import Foundation
import CoreDomain
import CoreData
import HeroCoreData
import OSLog

/// Core Data implementation for the student repository
public class CoreDataStudentRepository: CoreDataBaseRepository<StudentModel, Student, UUID>, AsyncStudentRepository {
    
    /// Logger for diagnostics and debugging
    private let logger = Logger(subsystem: "com.teccolino.hero8", category: "StudentRepository")
    
    /// Initializes a new student repository
    /// - Parameter context: The Core Data context
    public init(context: NSManagedObjectContext) {
        super.init(context: context, entityName: "Student")
    }
    
    // MARK: - Entity Mapping
    
    /// Converts a Core Data student object to a domain model
    /// - Parameter managedObject: The Core Data object
    /// - Returns: The domain model
    override public func mapToDomainEntity(_ managedObject: Student) -> StudentModel {
        return StudentModel(
            id: managedObject.id ?? UUID(),
            firstName: managedObject.firstName ?? "",
            lastName: managedObject.lastName ?? "",
            birthDate: managedObject.birthDate,
            notes: managedObject.notes,
            classId: managedObject.class_?.id,
            isArchived: managedObject.isArchived
        )
    }
    
    /// Updates a Core Data student object with the values of a domain model
    /// - Parameters:
    ///   - managedObject: The Core Data object
    ///   - entity: The domain model
    override public func updateManagedObject(_ managedObject: Student, with entity: StudentModel) {
        managedObject.id = entity.id
        managedObject.firstName = entity.firstName
        managedObject.lastName = entity.lastName
        managedObject.birthDate = entity.birthDate
        managedObject.notes = entity.notes
        managedObject.isArchived = entity.isArchived
        
        // Assign class if classId is present - do it synchronously here
        if let classId = entity.classId {
            do {
                // Using FetchRequestBuilder for class lookup
                let classObj = try context.fetch(
                    buildFetchRequest(Class.self)
                        .filtering(format: "id == %@", classId as CVarArg)
                        .limiting(to: 1)
                        .build()
                ).first
                
                managedObject.class_ = classObj
                if classObj == nil {
                    logger.warning("Class with ID \(classId.uuidString) not found for student \(entity.id.uuidString)")
                }
            } catch {
                logger.error("Failed to associate class: \(error.localizedDescription)")
                managedObject.class_ = nil
            }
        } else {
            managedObject.class_ = nil
        }
    }
    
    /// Creates a new Core Data student object from a domain model
    /// - Parameter entity: The domain model
    /// - Returns: The Core Data object
    override public func createManagedObject(from entity: StudentModel) -> Student {
        let newStudent = Student(context: context)
        updateManagedObject(newStudent, with: entity)
        return newStudent
    }
    
    /// Extracts the ID from a domain model
    /// - Parameter entity: The domain model
    /// - Returns: The UUID
    override public func getID(from entity: StudentModel) -> UUID {
        return entity.id
    }
    
    /// Creates a predicate for a student ID
    /// - Parameter id: The UUID
    /// - Returns: The NSPredicate
    override public func predicateForID(_ id: UUID) -> NSPredicate {
        return NSPredicate(format: "id == %@", id as CVarArg)
    }
    
    // MARK: - Repository Protocol Methods
    
    /// Fetches all students
    /// - Returns: List of all students
    public func fetchAll() async throws -> [StudentModel] {
        return try await performBackgroundTask { [self] context in
            let managedObjects = try context.fetch(
                self.createFetchRequestBuilder().build()
            )
            return managedObjects.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Fetches students with a specified filter
    /// - Parameter filter: The filter to apply
    /// - Returns: Filtered list of students
    public func fetchAll(filter: RepositoryFilter) async throws -> [StudentModel] {
        return try await performBackgroundTask { [self] context in
            let builder = self.createFetchRequestBuilder()
            let updatedBuilder = self.applyFilter(builder, filter: filter)
            let managedObjects = try context.fetch(updatedBuilder.build())
            return managedObjects.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Fetches a student by ID
    /// - Parameter id: The UUID of the student
    /// - Returns: The student or nil
    public func fetchOne(by id: UUID) async throws -> StudentModel? {
        return try await performBackgroundTask { [self] context in
            let managedObject = try context.fetch(
                buildFetchRequest(Student.self)
                    .filtering(with: self.predicateForID(id))
                    .limiting(to: 1)
                    .build()
            ).first
            
            return managedObject.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Saves a student
    /// - Parameter entity: The student to save
    /// - Returns: The saved student
    public func save(_ entity: StudentModel) async throws -> StudentModel {
        return try await performSave { [self] in
            do {
                // Look for existing object using Builder
                let existingObject = try self.context.fetch(
                    buildFetchRequest(Student.self)
                        .filtering(with: self.predicateForID(entity.id))
                        .limiting(to: 1)
                        .build()
                ).first
                
                if let existingObject = existingObject {
                    self.updateManagedObject(existingObject, with: entity)
                    return self.mapToDomainEntity(existingObject)
                } else {
                    let newObject = self.createManagedObject(from: entity)
                    return self.mapToDomainEntity(newObject)
                }
            } catch {
                throw error
            }
        }
    }
    
    /// Saves multiple students
    /// - Parameter entities: The students to save
    /// - Returns: The saved students
    public func saveAll(_ entities: [StudentModel]) async throws -> [StudentModel] {
        return try await performSave { [self] in
            do {
                let savedEntities = try entities.map { [self] entity -> StudentModel in
                    // Look for existing object using Builder for each entity
                    let existingObject = try self.context.fetch(
                        buildFetchRequest(Student.self)
                            .filtering(with: self.predicateForID(entity.id))
                            .limiting(to: 1)
                            .build()
                    ).first
                    
                    if let existingObject = existingObject {
                        self.updateManagedObject(existingObject, with: entity)
                        return self.mapToDomainEntity(existingObject)
                    } else {
                        let newObject = self.createManagedObject(from: entity)
                        return self.mapToDomainEntity(newObject)
                    }
                }
                
                return savedEntities
            } catch {
                throw error
            }
        }
    }
    
    /// Deletes a student by ID
    /// - Parameter id: The UUID of the student
    /// - Returns: true if successful
    public func delete(id: UUID) async throws -> Bool {
        return try await performSave { [self] in
            do {
                // Find object using Builder
                let managedObject = try self.context.fetch(
                    buildFetchRequest(Student.self)
                        .filtering(with: self.predicateForID(id))
                        .limiting(to: 1)
                        .build()
                ).first
                
                guard let managedObject = managedObject else {
                    return false
                }
                
                self.context.delete(managedObject)
                return true
            } catch {
                throw error
            }
        }
    }
    
    /// Deletes multiple students by ID
    /// - Parameter ids: The UUIDs of the students
    /// - Returns: true if successful
    public func deleteAll(ids: [UUID]) async throws -> Bool {
        return try await performSave { [self] in
            do {
                var success = true
                
                for id in ids {
                    // Find object using Builder for each ID
                    let managedObject = try self.context.fetch(
                        buildFetchRequest(Student.self)
                            .filtering(with: self.predicateForID(id))
                            .limiting(to: 1)
                            .build()
                    ).first
                    
                    if let managedObject = managedObject {
                        self.context.delete(managedObject)
                    } else {
                        success = false
                    }
                }
                
                return success
            } catch {
                throw error
            }
        }
    }
    
    // MARK: - Student-Specific Methods
    
    /// Fetches students for a specific class
    /// - Parameter classId: The UUID of the class
    /// - Returns: Students in the specified class
    public func fetchStudentsForClass(_ classId: UUID) async throws -> [StudentModel] {
        return try await performBackgroundTask { [self] context in
            let managedObjects = try context.fetch(
                buildFetchRequest(Student.self)
                    .filtering(format: "class_.id == %@", classId as CVarArg)
                    .sorting(by: "lastName", ascending: true)
                    .sorting(by: "firstName", ascending: true)
                    .build()
            )
            
            return managedObjects.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Fetches active students for a specific class
    /// - Parameter classId: The UUID of the class
    /// - Returns: Active students in the specified class
    public func fetchActiveStudentsForClass(_ classId: UUID) async throws -> [StudentModel] {
        return try await performBackgroundTask { [self] context in
            let managedObjects = try context.fetch(
                buildFetchRequest(Student.self)
                    .filtering(format: "class_.id == %@ AND isArchived == NO", classId as CVarArg)
                    .sorting(by: "lastName", ascending: true)
                    .sorting(by: "firstName", ascending: true)
                    .build()
            )
            
            return managedObjects.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Fetches archived students for a specific class
    /// - Parameter classId: The UUID of the class
    /// - Returns: Archived students in the specified class
    public func fetchArchivedStudentsForClass(_ classId: UUID) async throws -> [StudentModel] {
        return try await performBackgroundTask { [self] context in
            let managedObjects = try context.fetch(
                buildFetchRequest(Student.self)
                    .filtering(format: "class_.id == %@ AND isArchived == YES", classId as CVarArg)
                    .sorting(by: "lastName", ascending: true)
                    .sorting(by: "firstName", ascending: true)
                    .build()
            )
            
            return managedObjects.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Archives a student
    /// - Parameter id: The UUID of the student
    /// - Returns: true if successful
    public func archiveStudent(_ id: UUID) async throws -> Bool {
        return try await performSave { [self] in
            do {
                // Find object using Builder
                let managedObject = try self.context.fetch(
                    buildFetchRequest(Student.self)
                        .filtering(with: self.predicateForID(id))
                        .limiting(to: 1)
                        .build()
                ).first
                
                guard let managedObject = managedObject else {
                    return false
                }
                
                managedObject.isArchived = true
                return true
            } catch {
                throw error
            }
        }
    }
    
    /// Unarchives a student
    /// - Parameter id: The UUID of the student
    /// - Returns: true if successful
    public func unarchiveStudent(_ id: UUID) async throws -> Bool {
        return try await performSave { [self] in
            do {
                // Find object using Builder
                let managedObject = try self.context.fetch(
                    buildFetchRequest(Student.self)
                        .filtering(with: self.predicateForID(id))
                        .limiting(to: 1)
                        .build()
                ).first
                
                guard let managedObject = managedObject else {
                    return false
                }
                
                managedObject.isArchived = false
                return true
            } catch {
                throw error
            }
        }
    }
    
    /// Moves students to another class
    /// - Parameters:
    ///   - studentIds: The UUIDs of the students
    ///   - targetClassId: The UUID of the target class
    /// - Returns: true if successful
    public func moveStudentsToClass(studentIds: [UUID], targetClassId: UUID) async throws -> Bool {
        return try await performSave { [self] in
            do {
                // Find target class using Builder
                let targetClass = try self.context.fetch(
                    buildFetchRequest(Class.self)
                        .filtering(format: "id == %@", targetClassId as CVarArg)
                        .limiting(to: 1)
                        .build()
                ).first
                
                guard let targetClass = targetClass else {
                    self.logger.error("Target class not found: \(targetClassId.uuidString)")
                    return false
                }
                
                // Find and move students
                for studentId in studentIds {
                    // Find each student using Builder
                    let student = try self.context.fetch(
                        buildFetchRequest(Student.self)
                            .filtering(with: self.predicateForID(studentId))
                            .limiting(to: 1)
                            .build()
                    ).first
                    
                    if let student = student {
                        student.class_ = targetClass
                    } else {
                        self.logger.warning("Student not found: \(studentId.uuidString)")
                    }
                }
                
                return true
            } catch {
                throw error
            }
        }
    }
}