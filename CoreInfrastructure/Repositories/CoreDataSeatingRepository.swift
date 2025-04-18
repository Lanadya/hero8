//
//  CoreDataSeatingRepository.swift
//  CoreInfrastructure
//
//  Created for hero8 on 18.04.2025.
//

import Foundation
import CoreDomain
import HeroCoreData
import CoreData
import OSLog

/// Core Data implementation for the seating repository
public class CoreDataSeatingRepository: CoreDataBaseRepository<SeatingPositionModel, SeatingPosition, UUID>, AsyncSeatingRepository {
    
    /// Logger for diagnostics and debugging
    private let logger = Logger(subsystem: "com.teccolino.hero8", category: "SeatingRepository")
    
    /// Initializes a new seating repository
    /// - Parameter context: The Core Data context
    public init(context: NSManagedObjectContext) {
        super.init(context: context, entityName: "SeatingPosition")
    }
    
    // MARK: - Entity Mapping
    
    /// Converts a Core Data seating position object to a domain model
    /// - Parameter managedObject: The Core Data object
    /// - Returns: The domain model
    override public func mapToDomainEntity(_ managedObject: SeatingPosition) -> SeatingPositionModel {
        return SeatingPositionModel(
            id: managedObject.id ?? UUID(),
            studentId: managedObject.student?.id ?? UUID(),
            classId: managedObject.class_?.id ?? UUID(),
            row: Int(managedObject.row),
            column: Int(managedObject.column)
        )
    }
    
    /// Updates a Core Data seating position object with the values of a domain model
    /// - Parameters:
    ///   - managedObject: The Core Data object
    ///   - entity: The domain model
    override public func updateManagedObject(_ managedObject: SeatingPosition, with entity: SeatingPositionModel) {
        managedObject.id = entity.id
        managedObject.row = Int16(entity.row)
        managedObject.column = Int16(entity.column)
        
        // Assign student and class using FetchRequestBuilder
        do {
            // Fetch and assign student
            let student = try context.fetch(
                buildFetchRequest(Student.self)
                    .filtering(format: "id == %@", entity.studentId as CVarArg)
                    .limiting(to: 1)
                    .build()
            ).first
            
            if let student = student {
                managedObject.student = student
            } else {
                logger.warning("Student with ID \(entity.studentId.uuidString) not found for seating position \(entity.id.uuidString)")
                managedObject.student = nil
            }
            
            // Fetch and assign class
            let classObj = try context.fetch(
                buildFetchRequest(Class.self)
                    .filtering(format: "id == %@", entity.classId as CVarArg)
                    .limiting(to: 1)
                    .build()
            ).first
            
            if let classObj = classObj {
                managedObject.class_ = classObj
            } else {
                logger.warning("Class with ID \(entity.classId.uuidString) not found for seating position \(entity.id.uuidString)")
                managedObject.class_ = nil
            }
        } catch {
            logger.error("Failed to associate entities: \(error.localizedDescription)")
            managedObject.student = nil
            managedObject.class_ = nil
        }
    }
    
    /// Creates a new Core Data seating position object from a domain model
    /// - Parameter entity: The domain model
    /// - Returns: The Core Data object
    override public func createManagedObject(from entity: SeatingPositionModel) -> SeatingPosition {
        let newPosition = SeatingPosition(context: context)
        updateManagedObject(newPosition, with: entity)
        return newPosition
    }
    
    /// Extracts the ID from a domain model
    /// - Parameter entity: The domain model
    /// - Returns: The UUID
    override public func getID(from entity: SeatingPositionModel) -> UUID {
        return entity.id
    }
    
    /// Creates a predicate for a seating position ID
    /// - Parameter id: The UUID
    /// - Returns: The NSPredicate
    override public func predicateForID(_ id: UUID) -> NSPredicate {
        return NSPredicate(format: "id == %@", id as CVarArg)
    }
    
    // MARK: - Repository Protocol Methods
    
    /// Fetches all seating positions
    /// - Returns: List of all seating positions
    public func fetchAll() async throws -> [SeatingPositionModel] {
        return try await performBackgroundTask { [self] context in
            let managedObjects = try context.fetch(
                self.createFetchRequestBuilder().build()
            )
            return managedObjects.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Fetches seating positions with a specified filter
    /// - Parameter filter: The filter to apply
    /// - Returns: Filtered list of seating positions
    public func fetchAll(filter: RepositoryFilter) async throws -> [SeatingPositionModel] {
        return try await performBackgroundTask { [self] context in
            let builder = self.createFetchRequestBuilder()
            let updatedBuilder = self.applyFilter(builder, filter: filter)
            let managedObjects = try context.fetch(updatedBuilder.build())
            return managedObjects.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Fetches a seating position by ID
    /// - Parameter id: The UUID of the seating position
    /// - Returns: The seating position or nil
    public func fetchOne(by id: UUID) async throws -> SeatingPositionModel? {
        return try await performBackgroundTask { [self] context in
            let managedObject = try context.fetch(
                buildFetchRequest(SeatingPosition.self)
                    .filtering(with: self.predicateForID(id))
                    .limiting(to: 1)
                    .build()
            ).first
            
            return managedObject.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Saves a seating position
    /// - Parameter entity: The seating position to save
    /// - Returns: The saved seating position
    public func save(_ entity: SeatingPositionModel) async throws -> SeatingPositionModel {
        return try await performSave { [self] in
            do {
                // Look for existing object using Builder
                let existingObject = try self.context.fetch(
                    buildFetchRequest(SeatingPosition.self)
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
    
    /// Saves multiple seating positions
    /// - Parameter entities: The seating positions to save
    /// - Returns: The saved seating positions
    public func saveAll(_ entities: [SeatingPositionModel]) async throws -> [SeatingPositionModel] {
        return try await performSave { [self] in
            do {
                let savedEntities = try entities.map { [self] entity -> SeatingPositionModel in
                    // Look for existing object using Builder for each entity
                    let existingObject = try self.context.fetch(
                        buildFetchRequest(SeatingPosition.self)
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
    
    /// Deletes a seating position by ID
    /// - Parameter id: The UUID of the seating position
    /// - Returns: true if successful
    public func delete(id: UUID) async throws -> Bool {
        return try await performSave { [self] in
            do {
                // Find object using Builder
                let managedObject = try self.context.fetch(
                    buildFetchRequest(SeatingPosition.self)
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
    
    /// Deletes multiple seating positions by ID
    /// - Parameter ids: The UUIDs of the seating positions
    /// - Returns: true if successful
    public func deleteAll(ids: [UUID]) async throws -> Bool {
        return try await performSave { [self] in
            do {
                var success = true
                
                for id in ids {
                    // Find object using Builder for each ID
                    let managedObject = try self.context.fetch(
                        buildFetchRequest(SeatingPosition.self)
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
    
    // MARK: - Seating-Specific Methods
    
    /// Fetches seating positions for a specific class
    /// - Parameter classId: The UUID of the class
    /// - Returns: Seating positions in the specified class
    public func fetchPositionsForClass(_ classId: UUID) async throws -> [SeatingPositionModel] {
        return try await performBackgroundTask { [self] context in
            let managedObjects = try context.fetch(
                buildFetchRequest(SeatingPosition.self)
                    .filtering(format: "class_.id == %@", classId as CVarArg)
                    .sorting(by: "row", ascending: true)
                    .sorting(by: "column", ascending: true)
                    .build()
            )
            
            return managedObjects.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Updates seating positions
    /// - Parameter positions: The seating positions to update
    /// - Returns: The updated seating positions
    public func updatePositions(_ positions: [SeatingPositionModel]) async throws -> [SeatingPositionModel] {
        return try await saveAll(positions)
    }
    
    /// Deletes all seating positions for a class
    /// - Parameter classId: The UUID of the class
    /// - Returns: true if successful
    public func clearPositionsForClass(_ classId: UUID) async throws -> Bool {
        return try await performSave { [self] in
            let positions = try self.context.fetch(
                buildFetchRequest(SeatingPosition.self)
                    .filtering(format: "class_.id == %@", classId as CVarArg)
                    .build()
            )
            
            for position in positions {
                self.context.delete(position)
            }
            
            return true
        }
    }
    
    /// Fetches the seating position for a specific student
    /// - Parameter studentId: The UUID of the student
    /// - Returns: The seating position or nil
    public func getPositionForStudent(_ studentId: UUID) async throws -> SeatingPositionModel? {
        return try await performBackgroundTask { [self] context in
            let managedObject = try self.context.fetch(
                buildFetchRequest(SeatingPosition.self)
                    .filtering(format: "student.id == %@", studentId as CVarArg)
                    .limiting(to: 1)
                    .build()
            ).first
            
            return managedObject.map { self.mapToDomainEntity($0) }
        }
    }
}