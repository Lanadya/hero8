//
//  CoreDataRatingRepository.swift
//  CoreInfrastructure
//
//  Created for hero8 on 18.04.2025.
//

import Foundation
import CoreDomain
import HeroCoreData
import CoreData
import OSLog

/// Core Data implementation for the rating repository
public class CoreDataRatingRepository: CoreDataBaseRepository<RatingModel, Rating, UUID>, AsyncRatingRepository {
    
    /// Logger for diagnostics and debugging
    private let logger = Logger(subsystem: "com.teccolino.hero8", category: "RatingRepository")
    
    /// Initializes a new rating repository
    /// - Parameter context: The Core Data context
    public init(context: NSManagedObjectContext) {
        super.init(context: context, entityName: "Rating")
    }
    
    // MARK: - Entity Mapping
    
    /// Converts a Core Data rating object to a domain model
    /// - Parameter managedObject: The Core Data object
    /// - Returns: The domain model
    override public func mapToDomainEntity(_ managedObject: Rating) -> RatingModel {
        return RatingModel(
            id: managedObject.id ?? UUID(),
            studentId: managedObject.student?.id ?? UUID(),
            value: Int(managedObject.value),
            note: managedObject.note,
            date: managedObject.date ?? Date(),
            category: managedObject.category
        )
    }
    
    /// Updates a Core Data rating object with the values of a domain model
    /// - Parameters:
    ///   - managedObject: The Core Data object
    ///   - entity: The domain model
    override public func updateManagedObject(_ managedObject: Rating, with entity: RatingModel) {
        managedObject.id = entity.id
        managedObject.value = Int16(entity.value)
        managedObject.note = entity.note
        managedObject.date = entity.date
        managedObject.category = entity.category
        
        // Assign student using FetchRequestBuilder
        do {
            let student = try context.fetch(
                buildFetchRequest(Student.self)
                    .filtering(format: "id == %@", entity.studentId as CVarArg)
                    .limiting(to: 1)
                    .build()
            ).first
            
            if let student = student {
                managedObject.student = student
            } else {
                logger.warning("Student with ID \(entity.studentId.uuidString) not found for rating \(entity.id.uuidString)")
                managedObject.student = nil
            }
        } catch {
            logger.error("Failed to associate student: \(error.localizedDescription)")
            managedObject.student = nil
        }
    }
    
    /// Creates a new Core Data rating object from a domain model
    /// - Parameter entity: The domain model
    /// - Returns: The Core Data object
    override public func createManagedObject(from entity: RatingModel) -> Rating {
        let newRating = Rating(context: context)
        updateManagedObject(newRating, with: entity)
        return newRating
    }
    
    /// Extracts the ID from a domain model
    /// - Parameter entity: The domain model
    /// - Returns: The UUID
    override public func getID(from entity: RatingModel) -> UUID {
        return entity.id
    }
    
    /// Creates a predicate for a rating ID
    /// - Parameter id: The UUID
    /// - Returns: The NSPredicate
    override public func predicateForID(_ id: UUID) -> NSPredicate {
        return NSPredicate(format: "id == %@", id as CVarArg)
    }
    
    // MARK: - Repository Protocol Methods
    
    /// Fetches all ratings
    /// - Returns: List of all ratings
    public func fetchAll() async throws -> [RatingModel] {
        return try await performBackgroundTask { [self] context in
            let managedObjects = try context.fetch(
                self.createFetchRequestBuilder().build()
            )
            return managedObjects.map { value in self.mapToDomainEntity(value) }
        }
    }
    
    /// Fetches ratings with a specified filter
    /// - Parameter filter: The filter to apply
    /// - Returns: Filtered list of ratings
    public func fetchAll(filter: RepositoryFilter) async throws -> [RatingModel] {
        return try await performBackgroundTask { [self] context in
            let builder = self.createFetchRequestBuilder()
            let updatedBuilder = self.applyFilter(builder, filter: filter)
            let managedObjects = try context.fetch(updatedBuilder.build())
            return managedObjects.map { value in self.mapToDomainEntity(value) }
        }
    }
    
    /// Fetches a rating by ID
    /// - Parameter id: The UUID of the rating
    /// - Returns: The rating or nil
    public func fetchOne(by id: UUID) async throws -> RatingModel? {
        return try await performBackgroundTask { [self] context in
            let managedObject = try context.fetch(
                buildFetchRequest(Rating.self)
                    .filtering(with: self.predicateForID(id))
                    .limiting(to: 1)
                    .build()
            ).first
            
            return managedObject.map { value in self.mapToDomainEntity(value) }
        }
    }
    
    /// Saves a rating
    /// - Parameter entity: The rating to save
    /// - Returns: The saved rating
    public func save(_ entity: RatingModel) async throws -> RatingModel {
        return try await performSave { [self] in
            do {
                // Look for existing object using Builder
                let existingObject = try self.context.fetch(
                    buildFetchRequest(Rating.self)
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
    
    /// Saves multiple ratings
    /// - Parameter entities: The ratings to save
    /// - Returns: The saved ratings
    public func saveAll(_ entities: [RatingModel]) async throws -> [RatingModel] {
        return try await performSave { [self] in
            do {
                let savedEntities = try entities.map { [self] entity -> RatingModel in
                    // Look for existing object using Builder for each entity
                    let existingObject = try self.context.fetch(
                        buildFetchRequest(Rating.self)
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
    
    /// Deletes a rating by ID
    /// - Parameter id: The UUID of the rating
    /// - Returns: true if successful
    public func delete(id: UUID) async throws -> Bool {
        return try await performSave { [self] in
            do {
                // Find object using Builder
                let managedObject = try self.context.fetch(
                    buildFetchRequest(Rating.self)
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
    
    /// Deletes multiple ratings by ID
    /// - Parameter ids: The UUIDs of the ratings
    /// - Returns: true if successful
    public func deleteAll(ids: [UUID]) async throws -> Bool {
        return try await performSave { [self] in
            do {
                var success = true
                
                for id in ids {
                    // Find object using Builder for each ID
                    let managedObject = try self.context.fetch(
                        buildFetchRequest(Rating.self)
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
    
    // MARK: - Rating-Specific Methods
    
    /// Fetches ratings for a specific student
    /// - Parameter studentId: The UUID of the student
    /// - Returns: Ratings of the student
    public func fetchRatingsForStudent(_ studentId: UUID) async throws -> [RatingModel] {
        return try await performBackgroundTask { [self] context in
            let managedObjects = try self.context.fetch(
                buildFetchRequest(Rating.self)
                    .filtering(format: "student.id == %@", studentId as CVarArg)
                    .sorting(by: "date", ascending: false)
                    .build()
            )
            
            return managedObjects.map { value in self.mapToDomainEntity(value) }
        }
    }
    
    /// Fetches ratings for a specific date
    /// - Parameter date: The date
    /// - Returns: Ratings for the specified date
    public func fetchRatingsForDate(_ date: Date) async throws -> [RatingModel] {
        return try await performBackgroundTask { [self] context in
            // Create start and end of day for the date range
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let managedObjects = try self.context.fetch(
                buildFetchRequest(Rating.self)
                    .filtering(format: "date >= %@ AND date < %@", 
                              startOfDay as NSDate, 
                              endOfDay as NSDate)
                    .sorting(by: "student.lastName", ascending: true)
                    .sorting(by: "student.firstName", ascending: true)
                    .build()
            )
            
            return managedObjects.map { value in self.mapToDomainEntity(value) }
        }
    }
    
    /// Fetches ratings for a student in a specific date range
    /// - Parameters:
    ///   - studentId: The UUID of the student
    ///   - startDate: The start date
    ///   - endDate: The end date
    /// - Returns: Ratings in the specified date range
    public func fetchRatingsForStudentInDateRange(_ studentId: UUID, startDate: Date, endDate: Date) async throws -> [RatingModel] {
        return try await performBackgroundTask { [self] context in
            let managedObjects = try self.context.fetch(
                buildFetchRequest(Rating.self)
                    .filtering(format: "student.id == %@ AND date >= %@ AND date <= %@",
                              studentId as CVarArg,
                              startDate as NSDate,
                              endDate as NSDate)
                    .sorting(by: "date", ascending: false)
                    .build()
            )
            
            return managedObjects.map { value in self.mapToDomainEntity(value) }
        }
    }
    
    /// Fetches ratings for a class on a specific date
    /// - Parameters:
    ///   - classId: The UUID of the class
    ///   - date: The date
    /// - Returns: Ratings for the specified class on the specified date
    public func fetchRatingsForClass(_ classId: UUID, date: Date) async throws -> [RatingModel] {
        return try await performBackgroundTask { [self] context in
            // Create start and end of day for the date range
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let managedObjects = try self.context.fetch(
                buildFetchRequest(Rating.self)
                    .filtering(format: "student.class_.id == %@ AND date >= %@ AND date < %@",
                              classId as CVarArg,
                              startOfDay as NSDate,
                              endOfDay as NSDate)
                    .sorting(by: "student.lastName", ascending: true)
                    .sorting(by: "student.firstName", ascending: true)
                    .build()
            )
            
            return managedObjects.map { value in self.mapToDomainEntity(value) }
        }
    }
}