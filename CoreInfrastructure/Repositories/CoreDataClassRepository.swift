//
//  CoreDataClassRepository.swift
//  CoreInfrastructure
//
//  Created for hero8 on 18.04.2025.
//

import Foundation
import CoreDomain
import HeroCoreData
import CoreData

/// Core Data-Implementierung des ClassRepository
public class CoreDataClassRepository: CoreDataBaseRepository<ClassModel, Class, UUID>, AsyncClassRepository {
    
    /// Initialisiert das Repository mit einem Core Data-Kontext
    /// - Parameter context: Der Core Data-Kontext
    public init(context: NSManagedObjectContext) {
        super.init(context: context, entityName: "Class")
    }
    
    // MARK: - Mapping-Methoden
    
    /// Konvertiert ein Class-ManagedObject in ein ClassModel
    /// - Parameter managedObject: Das Core Data-Objekt
    /// - Returns: Das konvertierte ClassModel
    override public func mapToDomainEntity(_ managedObject: Class) -> ClassModel {
        return ClassModel(
            id: managedObject.id,
            name: managedObject.name,
            weekday: Int(managedObject.weekday),
            hour: Int(managedObject.hour),
            subject: managedObject.subject,
            room: managedObject.room,
            notes: managedObject.notes,
            isArchived: managedObject.isArchived
        )
    }
    
    /// Aktualisiert ein Class-ManagedObject mit den Werten eines ClassModels
    /// - Parameters:
    ///   - managedObject: Das zu aktualisierende Core Data-Objekt
    ///   - entity: Das ClassModel mit den neuen Werten
    override public func updateManagedObject(_ managedObject: Class, with entity: ClassModel) {
        managedObject.name = entity.name
        managedObject.weekday = Int16(entity.weekday)
        managedObject.hour = Int16(entity.hour)
        managedObject.subject = entity.subject
        managedObject.room = entity.room
        managedObject.notes = entity.notes
        managedObject.isArchived = entity.isArchived
    }
    
    /// Erstellt ein neues Class-ManagedObject aus einem ClassModel
    /// - Parameter entity: Das ClassModel
    /// - Returns: Das neue Class-ManagedObject
    override public func createManagedObject(from entity: ClassModel) -> Class {
        let newClass = Class(context: context)
        newClass.id = entity.id
        updateManagedObject(newClass, with: entity)
        return newClass
    }
    
    /// Extrahiert die ID aus einem ClassModel
    /// - Parameter entity: Das ClassModel
    /// - Returns: Die UUID
    override public func getID(from entity: ClassModel) -> UUID {
        return entity.id
    }
    
    /// Erstellt ein NSPredicate für eine UUID
    /// - Parameter id: Die UUID
    /// - Returns: Das NSPredicate
    override public func predicateForID(_ id: UUID) -> NSPredicate {
        return NSPredicate(format: "id == %@", id as CVarArg)
    }
    
    // MARK: - AsyncClassRepository Protocol
    
    /// Holt alle Klassen
    /// - Returns: Alle Klassen als ClassModels
    public func fetchAll() async throws -> [ClassModel] {
        return try await performBackgroundTask { context in
            let fetchRequest = self.createFetchRequest()
            let sortByWeekday = NSSortDescriptor(key: "weekday", ascending: true)
            let sortByHour = NSSortDescriptor(key: "hour", ascending: true)
            fetchRequest.sortDescriptors = [sortByWeekday, sortByHour]
            
            let results = try context.fetch(fetchRequest)
            return results.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Holt Klassen mit einem Filter
    /// - Parameter filter: Der Filter
    /// - Returns: Die gefilterten Klassen als ClassModels
    public func fetchAll(filter: RepositoryFilter) async throws -> [ClassModel] {
        return try await performBackgroundTask { context in
            let fetchRequest = self.createFetchRequest()
            self.applyFilter(fetchRequest, filter: filter)
            
            let results = try context.fetch(fetchRequest)
            return results.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Holt eine Klasse anhand ihrer ID
    /// - Parameter id: Die UUID der Klasse
    /// - Returns: Das ClassModel oder nil, wenn nicht gefunden
    public func fetchOne(by id: UUID) async throws -> ClassModel? {
        if let managedObject = try await findByID(id) {
            return mapToDomainEntity(managedObject)
        }
        return nil
    }
    
    /// Speichert eine Klasse
    /// - Parameter entity: Das zu speichernde ClassModel
    /// - Returns: Das gespeicherte ClassModel
    public func save(_ entity: ClassModel) async throws -> ClassModel {
        return try await performSave {
            let id = self.getID(from: entity)
            
            if let existingClass = try self.findByIDSync(id) {
                // Bestehende Klasse aktualisieren
                self.updateManagedObject(existingClass, with: entity)
                return self.mapToDomainEntity(existingClass)
            } else {
                // Neue Klasse erstellen
                let newClass = self.createManagedObject(from: entity)
                return self.mapToDomainEntity(newClass)
            }
        }
    }
    
    /// Speichert mehrere Klassen
    /// - Parameter entities: Die zu speichernden ClassModels
    /// - Returns: Die gespeicherten ClassModels
    public func saveAll(_ entities: [ClassModel]) async throws -> [ClassModel] {
        return try await performSave {
            var savedEntities: [ClassModel] = []
            
            for entity in entities {
                let id = self.getID(from: entity)
                
                if let existingClass = try self.findByIDSync(id) {
                    self.updateManagedObject(existingClass, with: entity)
                    savedEntities.append(self.mapToDomainEntity(existingClass))
                } else {
                    let newClass = self.createManagedObject(from: entity)
                    savedEntities.append(self.mapToDomainEntity(newClass))
                }
            }
            
            return savedEntities
        }
    }
    
    /// Löscht eine Klasse anhand ihrer ID
    /// - Parameter id: Die UUID der Klasse
    /// - Returns: true, wenn die Klasse gelöscht wurde
    public func delete(id: UUID) async throws -> Bool {
        return try await performSave {
            if let existingClass = try self.findByIDSync(id) {
                self.context.delete(existingClass)
                return true
            }
            return false
        }
    }
    
    /// Löscht mehrere Klassen anhand ihrer IDs
    /// - Parameter ids: Die UUIDs der Klassen
    /// - Returns: true, wenn alle Klassen gelöscht wurden
    public func deleteAll(ids: [UUID]) async throws -> Bool {
        return try await performSave {
            var allDeleted = true
            
            for id in ids {
                if let existingClass = try self.findByIDSync(id) {
                    self.context.delete(existingClass)
                } else {
                    allDeleted = false
                }
            }
            
            return allDeleted
        }
    }
    
    /// Holt Klassen für einen bestimmten Wochentag
    /// - Parameter weekday: Der Wochentag (0-6, wobei 0 Montag ist)
    /// - Returns: Die Klassen für den Wochentag als ClassModels
    public func fetchClassesForDay(_ weekday: Int) async throws -> [ClassModel] {
        return try await performBackgroundTask { context in
            let fetchRequest = self.createFetchRequest()
            fetchRequest.predicate = NSPredicate(format: "weekday == %d", weekday)
            
            let sortByHour = NSSortDescriptor(key: "hour", ascending: true)
            fetchRequest.sortDescriptors = [sortByHour]
            
            let results = try context.fetch(fetchRequest)
            return results.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Holt aktive (nicht archivierte) Klassen
    /// - Returns: Die aktiven Klassen als ClassModels
    public func fetchActiveClasses() async throws -> [ClassModel] {
        return try await performBackgroundTask { context in
            let fetchRequest = self.createFetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isArchived == NO")
            
            let sortByWeekday = NSSortDescriptor(key: "weekday", ascending: true)
            let sortByHour = NSSortDescriptor(key: "hour", ascending: true)
            fetchRequest.sortDescriptors = [sortByWeekday, sortByHour]
            
            let results = try context.fetch(fetchRequest)
            return results.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Holt archivierte Klassen
    /// - Returns: Die archivierten Klassen als ClassModels
    public func fetchArchivedClasses() async throws -> [ClassModel] {
        return try await performBackgroundTask { context in
            let fetchRequest = self.createFetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isArchived == YES")
            
            let sortByName = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortByName]
            
            let results = try context.fetch(fetchRequest)
            return results.map { self.mapToDomainEntity($0) }
        }
    }
    
    /// Archiviert eine Klasse
    /// - Parameter id: Die UUID der Klasse
    /// - Returns: true, wenn die Klasse archiviert wurde
    public func archiveClass(_ id: UUID) async throws -> Bool {
        return try await performSave {
            if let existingClass = try self.findByIDSync(id) {
                existingClass.isArchived = true
                return true
            }
            return false
        }
    }
    
    /// Hebt die Archivierung einer Klasse auf
    /// - Parameter id: Die UUID der Klasse
    /// - Returns: true, wenn die Archivierung der Klasse aufgehoben wurde
    public func unarchiveClass(_ id: UUID) async throws -> Bool {
        return try await performSave {
            if let existingClass = try self.findByIDSync(id) {
                existingClass.isArchived = false
                return true
            }
            return false
        }
    }
}
