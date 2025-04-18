//
//  CoreDataBaseRepository.swift
//  CoreInfrastructure
//
//  Created for hero8 on 18.04.2025.
//

import Foundation
import CoreDomain
import OSLog
import HeroCoreData
import CoreData

/// Basis-Implementierung für Core Data-Repositories
open class CoreDataBaseRepository<Entity, ManagedObject: NSManagedObject, ID> {
    /// Logger für Diagnose und Debugging
    private let logger = Logger(subsystem: "com.teccolino.hero8", category: "Repository")
    
    /// Der Core Data-Kontext
    public let context: NSManagedObjectContext
    
    /// Entity-Name in Core Data
    private let entityName: String
    
    /// Initialisiert ein Repository mit einem Core Data-Kontext
    /// - Parameters:
    ///   - context: Der Core Data-Kontext
    ///   - entityName: Der Name der Entity in Core Data
    public init(context: NSManagedObjectContext, entityName: String) {
        self.context = context
        self.entityName = entityName
    }
    
    // MARK: - Konvertierungsmethoden (müssen von Unterklassen überschrieben werden)
    
    /// Konvertiert ein NSManagedObject in eine Domänenentität
    /// - Parameter managedObject: Das Core Data-Objekt
    /// - Returns: Die konvertierte Domänenentität
    open func mapToDomainEntity(_ managedObject: ManagedObject) -> Entity {
        fatalError("mapToDomainEntity(_:) must be overridden by subclass")
    }
    
    /// Aktualisiert ein NSManagedObject mit den Werten einer Domänenentität
    /// - Parameters:
    ///   - managedObject: Das zu aktualisierende Core Data-Objekt
    ///   - entity: Die Domänenentität mit den neuen Werten
    open func updateManagedObject(_ managedObject: ManagedObject, with entity: Entity) {
        fatalError("updateManagedObject(_:with:) must be overridden by subclass")
    }
    
    /// Erstellt ein neues NSManagedObject aus einer Domänenentität
    /// - Parameter entity: Die Domänenentität
    /// - Returns: Das neue Core Data-Objekt
    open func createManagedObject(from entity: Entity) -> ManagedObject {
        fatalError("createManagedObject(from:) must be overridden by subclass")
    }
    
    /// Extrahiert die ID aus einer Domänenentität
    /// - Parameter entity: Die Domänenentität
    /// - Returns: Die ID
    open func getID(from entity: Entity) -> ID {
        fatalError("getID(from:) must be overridden by subclass")
    }
    
    /// Erstellt ein NSPredicate für eine ID
    /// - Parameter id: Die ID
    /// - Returns: Das NSPredicate
    open func predicateForID(_ id: ID) -> NSPredicate {
        fatalError("predicateForID(_:) must be overridden by subclass")
    }
    
    // MARK: - Hilfsmethoden
    
    /// Erstellt einen Fetch Request für den Entity-Typ
    /// - Returns: Der typisierte NSFetchRequest
    public func createFetchRequest() -> NSFetchRequest<ManagedObject> {
        return NSFetchRequest<ManagedObject>(entityName: entityName)
    }
    
    /// Wendet Filter auf einen Fetch Request an
    /// - Parameters:
    ///   - fetchRequest: Der zu ändernde Fetch Request
    ///   - filter: Die anzuwendenden Filter
    public func applyFilter(_ fetchRequest: NSFetchRequest<ManagedObject>, filter: RepositoryFilter) {
        if let predicate = filter.predicate as? NSPredicate {
            fetchRequest.predicate = predicate
        }
        
        if let sortDescriptors = filter.sortDescriptors as? [NSSortDescriptor] {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        if let fetchLimit = filter.fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        if let fetchOffset = filter.fetchOffset {
            fetchRequest.fetchOffset = fetchOffset
        }
    }
    
    /// Findet ein NSManagedObject anhand seiner ID
    /// - Parameter id: Die ID des Objekts
    /// - Returns: Das gefundene Objekt oder nil
    public func findByID(_ id: ID) async throws -> ManagedObject? {
        return try await performBackgroundTask { context in
            let fetchRequest = self.createFetchRequest()
            fetchRequest.predicate = self.predicateForID(id)
            fetchRequest.fetchLimit = 1
            
            let results = try context.fetch(fetchRequest)
            return results.first
        }
    }
    
    /// Synchrone Version der findByID-Methode
    /// - Parameter id: Die ID des Objekts
    /// - Returns: Das gefundene Objekt oder nil
    public func findByIDSync(_ id: ID) throws -> ManagedObject? {
        let fetchRequest = self.createFetchRequest()
        fetchRequest.predicate = self.predicateForID(id)
        fetchRequest.fetchLimit = 1
        
        let results = try context.fetch(fetchRequest)
        return results.first
    }
    
    /// Führt eine Aufgabe in einem Hintergrundkontext aus
    /// - Parameter task: Die auszuführende Aufgabe
    /// - Returns: Das Ergebnis der Aufgabe
    public func performBackgroundTask<T>(_ task: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let result = try task(self.context)
                    continuation.resume(returning: result)
                } catch {
                    self.logger.error("Repository error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Prüft, ob eine Entity mit einer bestimmten ID existiert
    /// - Parameter id: Die zu prüfende ID
    /// - Returns: true, wenn die Entity existiert
    public func exists(id: ID) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let fetchRequest = self.createFetchRequest()
                    fetchRequest.predicate = self.predicateForID(id)
                    fetchRequest.fetchLimit = 1
                    
                    // Nur die ID abrufen, um Performance zu verbessern
                    fetchRequest.resultType = .countResultType
                    
                    let count = try self.context.count(for: fetchRequest)
                    continuation.resume(returning: count > 0)
                } catch {
                    self.logger.error("Repository exists check error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Führt eine Speicheroperation im Kontext aus
    /// - Parameter block: Der auszuführende Block
    /// - Returns: Das Ergebnis des Blocks
    public func performSave<T>(_ block: @escaping () throws -> T) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let result = try block()
                    
                    if self.context.hasChanges {
                        try self.context.save()
                    }
                    
                    continuation.resume(returning: result)
                } catch {
                    self.logger.error("Repository save error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
