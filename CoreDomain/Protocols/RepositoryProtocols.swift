//
//  RepositoryProtocols.swift
//  CoreDomain
//
//  Created for hero8 on 18.04.2025.
//

import Foundation

// MARK: - Repository Filter

/// Filteroption für Repository-Abfragen
public struct RepositoryFilter {
    /// Ein optionales Prädikat, um die Ergebnisse zu filtern
    public let predicate: Any?
    
    /// Optionale Sortierkriterien
    public let sortDescriptors: [Any]?
    
    /// Optionale Begrenzung der Anzahl der zurückgegebenen Ergebnisse
    public let fetchLimit: Int?
    
    /// Optionaler Offset für die Ergebnisse
    public let fetchOffset: Int?
    
    /// Initialisiert einen neuen RepositoryFilter
    /// - Parameters:
    ///   - predicate: Ein optionales Prädikat zur Filterung
    ///   - sortDescriptors: Optionale Sortierkriterien
    ///   - fetchLimit: Optionale Begrenzung der Anzahl der Ergebnisse
    ///   - fetchOffset: Optionaler Offset für die Ergebnisse
    public init(
        predicate: Any? = nil,
        sortDescriptors: [Any]? = nil,
        fetchLimit: Int? = nil,
        fetchOffset: Int? = nil
    ) {
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
        self.fetchLimit = fetchLimit
        self.fetchOffset = fetchOffset
    }
    
    /// Ein leerer Filter ohne Einschränkungen
    public static var none: RepositoryFilter {
        return RepositoryFilter()
    }
}

// MARK: - Base Repository Protocol

/// Basisprotokoll für alle Repositories
public protocol AsyncRepository {
    /// Der Typ der Entität, die vom Repository verwaltet wird
    associatedtype Entity
    
    /// Der Typ der ID, die zum Identifizieren der Entität verwendet wird
    associatedtype ID
    
    /// Holt alle Entitäten
    func fetchAll() async throws -> [Entity]
    
    /// Holt Entitäten mit einem angegebenen Filter
    func fetchAll(filter: RepositoryFilter) async throws -> [Entity]
    
    /// Holt eine einzelne Entität anhand ihrer ID
    func fetchOne(by id: ID) async throws -> Entity?
    
    /// Speichert eine Entität
    func save(_ entity: Entity) async throws -> Entity
    
    /// Speichert mehrere Entitäten
    func saveAll(_ entities: [Entity]) async throws -> [Entity]
    
    /// Löscht eine Entität anhand ihrer ID
    func delete(id: ID) async throws -> Bool
    
    /// Löscht mehrere Entitäten anhand ihrer IDs
    func deleteAll(ids: [ID]) async throws -> Bool
}

// MARK: - Class Repository Protocol

/// Repository für die Verwaltung von Klassen
public protocol AsyncClassRepository: AsyncRepository where Entity == ClassModel, ID == UUID {
    /// Holt Klassen für einen bestimmten Wochentag
    func fetchClassesForDay(_ weekday: Int) async throws -> [ClassModel]
    
    /// Holt aktive (nicht archivierte) Klassen
    func fetchActiveClasses() async throws -> [ClassModel]
    
    /// Holt archivierte Klassen
    func fetchArchivedClasses() async throws -> [ClassModel]
    
    /// Archiviert eine Klasse
    func archiveClass(_ id: UUID) async throws -> Bool
    
    /// Hebt die Archivierung einer Klasse auf
    func unarchiveClass(_ id: UUID) async throws -> Bool
}

// MARK: - Student Repository Protocol

/// Repository für die Verwaltung von Schülern
public protocol AsyncStudentRepository: AsyncRepository where Entity == StudentModel, ID == UUID {
    /// Holt alle Schüler für eine bestimmte Klasse
    func fetchStudentsForClass(_ classId: UUID) async throws -> [StudentModel]
    
    /// Holt aktive (nicht archivierte) Schüler für eine bestimmte Klasse
    func fetchActiveStudentsForClass(_ classId: UUID) async throws -> [StudentModel]
    
    /// Holt archivierte Schüler für eine bestimmte Klasse
    func fetchArchivedStudentsForClass(_ classId: UUID) async throws -> [StudentModel]
    
    /// Archiviert einen Schüler
    func archiveStudent(_ id: UUID) async throws -> Bool
    
    /// Hebt die Archivierung eines Schülers auf
    func unarchiveStudent(_ id: UUID) async throws -> Bool
    
    /// Verschiebt Schüler in eine andere Klasse
    func moveStudentsToClass(studentIds: [UUID], targetClassId: UUID) async throws -> Bool
}

// MARK: - Rating Repository Protocol

/// Repository für die Verwaltung von Bewertungen
public protocol AsyncRatingRepository: AsyncRepository where Entity == RatingModel, ID == UUID {
    /// Holt Bewertungen für einen bestimmten Schüler
    func fetchRatingsForStudent(_ studentId: UUID) async throws -> [RatingModel]
    
    /// Holt Bewertungen für ein bestimmtes Datum
    func fetchRatingsForDate(_ date: Date) async throws -> [RatingModel]
    
    /// Holt Bewertungen für einen Schüler in einem bestimmten Zeitraum
    func fetchRatingsForStudentInDateRange(_ studentId: UUID, startDate: Date, endDate: Date) async throws -> [RatingModel]
    
    /// Holt Bewertungen für eine Klasse an einem bestimmten Datum
    func fetchRatingsForClass(_ classId: UUID, date: Date) async throws -> [RatingModel]
}

// MARK: - Seating Repository Protocol

/// Repository für die Verwaltung von Sitzpositionen
public protocol AsyncSeatingRepository: AsyncRepository where Entity == SeatingPositionModel, ID == UUID {
    /// Holt Sitzpositionen für eine bestimmte Klasse
    func fetchPositionsForClass(_ classId: UUID) async throws -> [SeatingPositionModel]
    
    /// Aktualisiert Sitzpositionen
    func updatePositions(_ positions: [SeatingPositionModel]) async throws -> [SeatingPositionModel]
    
    /// Löscht alle Sitzpositionen für eine Klasse
    func clearPositionsForClass(_ classId: UUID) async throws -> Bool
    
    /// Holt die Sitzposition für einen bestimmten Schüler
    func getPositionForStudent(_ studentId: UUID) async throws -> SeatingPositionModel?
}
