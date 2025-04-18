//
//  PersistenceController.swift
//  HeroCoreData
//
//  Created for hero8 on 18.04.2025.
//

import Foundation
import CoreData
import os.log

/// Controller für die Verwaltung der Core Data Persistenz
public class PersistenceController {
    /// Logger für Diagnose und Debugging
    private let logger = Logger(subsystem: "com.teccolino.hero8", category: "PersistenceController")
    
    /// Shared Instance für die Anwendung
    public static let shared = PersistenceController()
    
    /// Preview Instance für SwiftUI-Previews
    public static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        // Beispieldaten für Preview hinzufügen
        let viewContext = controller.container.viewContext
        
        do {
            // Grundlegende Beispieldaten
            let testClass = Class(context: viewContext)
            testClass.id = UUID()
            testClass.name = "Testklasse"
            testClass.weekday = 1
            testClass.hour = 1
            testClass.isArchived = false
            
            let testStudent = Student(context: viewContext)
            testStudent.id = UUID()
            testStudent.firstName = "Vorname"
            testStudent.lastName = "Nachname"
            testStudent.isArchived = false
            testStudent.class_ = testClass
            
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            controller.logger.error("PersistenceController Preview-Initialisierung fehlgeschlagen: \(nsError), \(nsError.userInfo)")
            fatalError("PersistenceController Preview-Initialisierung fehlgeschlagen: \(nsError), \(nsError.userInfo)")
        }
        
        return controller
    }()
    
    /// Core Data Container
    public let container: NSPersistentContainer
    
    /// Migrationsoptionen für das Core Data Modell
    public enum MigrationOptions {
        case lightweight
        case manual(mappingModel: NSMappingModel)
    }
    
    /// Speichertyp für den Persistent Store
    public enum StoreType {
        case sqlite
        case binary
        case inMemory
    }
    
    /// Speicheroptionen für den Persistent Store
    public struct StoreOptions {
        let type: StoreType
        let url: URL?
        let migration: MigrationOptions?
        let readOnly: Bool
        
        public init(
            type: StoreType = .sqlite,
            url: URL? = nil,
            migration: MigrationOptions? = .lightweight,
            readOnly: Bool = false
        ) {
            self.type = type
            self.url = url
            self.migration = migration
            self.readOnly = readOnly
        }
    }
    
    /// Erstellt einen neuen PersistenceController
    /// - Parameters:
    ///   - inMemory: Ob ein In-Memory-Store verwendet werden soll
    ///   - storeOptions: Benutzerdefinierte Store-Optionen
    public init(inMemory: Bool = false, storeOptions: StoreOptions? = nil) {
        container = NSPersistentContainer(name: "HeroCoreDataModel")
        
        let options = storeOptions ?? (inMemory ? 
                                     StoreOptions(type: .inMemory, url: nil, migration: nil, readOnly: false) :
                                     StoreOptions())
        
        configureStoreOptions(options, inMemory: inMemory)
        
        container.loadPersistentStores { [weak self] description, error in
            if let error = error as NSError? {
                self?.logger.error("Fehler beim Laden der Persistent Stores: \(error), \(error.userInfo)")
                // In einer Produktionsapp sollte das besser behandelt werden
                fatalError("Fehler beim Laden der Persistent Stores: \(error), \(error.userInfo)")
            }
            
            self?.logger.debug("Persistent Store erfolgreich geladen: \(description.url?.absoluteString ?? "unbekannt")")
        }
        
        // Core Data Stack konfigurieren
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Timeout für Abfragen setzen
        container.viewContext.stalenessInterval = 0.0
    }
    
    /// Konfiguriert Store-Optionen für den Persistent Container
    /// - Parameters:
    ///   - options: Die Store-Optionen
    ///   - inMemory: Ob ein In-Memory-Store verwendet werden soll (überschreibt options.type, wenn true)
    private func configureStoreOptions(_ options: StoreOptions, inMemory: Bool) {
        guard let description = container.persistentStoreDescriptions.first else {
            return
        }
        
        // Store-Typ setzen
        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
            description.type = NSInMemoryStoreType
        } else {
            switch options.type {
            case .sqlite:
                description.type = NSSQLiteStoreType
            case .binary:
                description.type = NSBinaryStoreType
            case .inMemory:
                description.type = NSInMemoryStoreType
            }
            
            if let url = options.url {
                description.url = url
            }
        }
        
        // Migrationsoptionen konfigurieren
        if let migration = options.migration {
            switch migration {
            case .lightweight:
                description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
                description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
            case .manual(let mappingModel):
                description.setOption(false as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
                description.setOption(mappingModel, forKey: NSMigrationManagerKey)
            }
        }
        
        // Read-Only setzen, wenn nötig
        if options.readOnly {
            description.setOption(true as NSNumber, forKey: NSReadOnlyPersistentStoreOption)
        }
        
        // Für bessere Performance konfigurieren
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
    }
    
    /// Gibt den Haupt-View-Context zurück
    public var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    /// Erstellt einen neuen Hintergrund-Context für asynchrone Operationen
    /// - Returns: Ein neuer NSManagedObjectContext im Hintergrund
    public func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    /// Führt eine Aufgabe in einem Hintergrund-Context aus
    /// - Parameter task: Die auszuführende Aufgabe
    public func performBackgroundTask(_ task: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask(task)
    }
    
    /// Führt eine asynchrone Aufgabe in einem Hintergrund-Context aus
    /// - Parameter task: Die auszuführende Aufgabe
    /// - Returns: Das Ergebnis der Aufgabe
    public func performBackgroundTask<T>(_ task: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            container.performBackgroundTask { context in
                do {
                    let result = try task(context)
                    continuation.resume(returning: result)
                } catch {
                    self.logger.error("Fehler bei Hintergrundaufgabe: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Speichert den View-Context, wenn er Änderungen enthält
    /// - Throws: Wenn das Speichern fehlschlägt
    public func saveContext() throws {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                logger.debug("View Context erfolgreich gespeichert")
            } catch {
                logger.error("Fehler beim Speichern des View Context: \(error.localizedDescription)")
                throw error
            }
        }
    }
    
    /// Speichert den View-Context asynchron, wenn er Änderungen enthält
    /// - Throws: Wenn das Speichern fehlschlägt
    public func saveContext() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            viewContext.perform {
                do {
                    if self.viewContext.hasChanges {
                        try self.viewContext.save()
                        self.logger.debug("View Context erfolgreich gespeichert (async)")
                    }
                    continuation.resume(returning: ())
                } catch {
                    self.logger.error("Fehler beim asynchronen Speichern des Context: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Setzt den Persistent Store zurück - ACHTUNG: Löscht alle Daten
    /// - Throws: Wenn das Zurücksetzen fehlschlägt
    public func resetPersistentStore() throws {
        logger.warning("Persistent Store wird zurückgesetzt - ALLE DATEN WERDEN GELÖSCHT")
        
        guard let storeURL = container.persistentStoreDescriptions.first?.url else {
            throw NSError(domain: "com.teccolino.hero8", code: 1, userInfo: [NSLocalizedDescriptionKey: "Store-URL konnte nicht gefunden werden"])
        }
        
        // Bestehenden Persistent Store zerstören
        try container.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
        
        // Persistent Store neu erstellen
        try container.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        
        // View Context zurücksetzen
        container.viewContext.reset()
        
        logger.debug("Persistent Store erfolgreich zurückgesetzt")
    }
    
    /// Führt ein Rollback auf dem View Context durch
    public func rollback() {
        viewContext.rollback()
        logger.debug("View Context zurückgesetzt")
    }
    
    /// Führt ein Refresh auf allen Objekten im View Context durch
    public func refreshAllObjects() {
        viewContext.refreshAllObjects()
        logger.debug("Alle Objekte aktualisiert")
    }
    
    /// Prüft, ob eine Migration für den Persistent Store notwendig ist
    /// - Returns: true, wenn eine Migration notwendig ist
    public func isMigrationNeeded() -> Bool {
        guard let storeURL = container.persistentStoreDescriptions.first?.url else {
            return false
        }
        
        // Prüfen, ob der Store existiert
        guard FileManager.default.fileExists(atPath: storeURL.path) else {
            return false
        }
        
        do {
            // Versuchen zu bestimmen, ob eine Migration notwendig ist
            let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: storeURL, options: nil)
            let model = container.managedObjectModel
            return !model.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
        } catch {
            logger.error("Fehler beim Prüfen des Migrationsstatus: \(error.localizedDescription)")
            return false
        }
    }
}
