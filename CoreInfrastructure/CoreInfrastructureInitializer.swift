//
//  CoreInfrastructureInitializer.swift
//  CoreInfrastructure
//
//  Created for hero8 on 18.04.2025.
//

import Foundation
import HeroCoreData
import CoreDomain
import CoreData

/// Klasse zur Initialisierung des CoreInfrastructure-Moduls
public class CoreInfrastructureInitializer {
    /// Singleton-Instanz
    public static let shared = CoreInfrastructureInitializer()
    
    private init() {}
    
    /// Storage für Repositories
    private var repositories: [String: Any] = [:]
    
    /// Konfiguriert das CoreInfrastructure-Modul
    /// - Parameters:
    ///   - persistenceController: Der PersistenceController für Core Data
    ///   - configuration: Optionale Konfigurationsparameter
    public func configure(persistenceController: PersistenceController, configuration: [String: Any]? = nil) {
        // Repository-Instanzen erstellen
        let classRepository = CoreDataClassRepository(context: persistenceController.viewContext)
        
        // Repositories speichern
        repositories["class"] = classRepository
        
        // Weitere Konfigurationen könnten hier durchgeführt werden
    }
    
    /// Gibt ein Repository zurück
    /// - Parameter type: Der Typ des Repositories
    /// - Returns: Das Repository oder nil, wenn nicht gefunden
    public func repository<T>(of type: T.Type) -> T? {
        let typeString = String(describing: type)
        
        if typeString.contains("ClassRepository") {
            return repositories["class"] as? T
        }
        
        // Weitere Repository-Typen können hier hinzugefügt werden
        
        return nil
    }
}
