import Foundation
import CoreData
import CoreDomain
import HeroCoreData

/// Extension to integrate FetchRequestBuilder with CoreDataBaseRepository
extension CoreDataBaseRepository {
    
    /// Creates a fetch request builder for this repository's entity type
    /// - Returns: A configured FetchRequestBuilder
    func createFetchRequestBuilder() -> FetchRequestBuilder<ManagedObject> {
        return buildFetchRequest(ManagedObject.self)
    }
    
    /// Applies repository filters to a fetch request builder
    /// - Parameters:
    ///   - builder: The fetch request builder
    ///   - filter: The repository filter
    /// - Returns: The updated fetch request builder
    func applyFilter(_ builder: FetchRequestBuilder<ManagedObject>, filter: RepositoryFilter) -> FetchRequestBuilder<ManagedObject> {
        // Start with a clean builder
        var predicates: [NSPredicate] = []
        
        // Add predicate if needed
        if let predicate = filter.predicate as? NSPredicate {
            predicates.append(predicate)
        }
        
        // Apply all predicates
        if !predicates.isEmpty {
            if predicates.count == 1 {
                builder.filtering(with: predicates[0])
            } else {
                builder.filtering(with: predicates)
            }
        }
        
        // Apply sorting
        if let sortDescriptors = filter.sortDescriptors as? [NSSortDescriptor], !sortDescriptors.isEmpty {
            builder.sorting(with: sortDescriptors)
        }
        
        // Apply pagination if needed
        if let fetchLimit = filter.fetchLimit, fetchLimit > 0 {
            builder.limiting(to: fetchLimit)
        }
        
        if let fetchOffset = filter.fetchOffset, fetchOffset > 0 {
            builder.skipping(fetchOffset)
        }
        
        return builder
    }
    
    /// Executes a fetch operation using the FetchRequestBuilder
    /// - Parameters:
    ///   - builder: The fetch request builder
    ///   - context: The managed object context (defaults to this repository's context)
    /// - Returns: Array of fetched objects
    /// - Throws: Core Data errors
    func executeFetch(_ builder: FetchRequestBuilder<ManagedObject>, context: NSManagedObjectContext? = nil) throws -> [ManagedObject] {
        let request = builder.build()
        return try (context ?? self.context).fetch(request)
    }
    
    /// Executes a fetch operation asynchronously using the FetchRequestBuilder
    /// - Parameters:
    ///   - builder: The fetch request builder
    ///   - context: The managed object context (defaults to this repository's context)
    /// - Returns: Array of fetched objects
    /// - Throws: Core Data errors
    func executeFetch(_ builder: FetchRequestBuilder<ManagedObject>) async throws -> [ManagedObject] {
        let request = builder.build()
        return try await context.fetch(request)
    }
    
    /// Counts objects using the FetchRequestBuilder
    /// - Parameters:
    ///   - builder: The fetch request builder
    ///   - context: The managed object context (defaults to this repository's context)
    /// - Returns: Count of matching objects
    /// - Throws: Core Data errors
    func executeCount(_ builder: FetchRequestBuilder<ManagedObject>, context: NSManagedObjectContext? = nil) throws -> Int {
        let request = builder.returningCount().build()
        return try (context ?? self.context).count(for: request)
    }
    
    /// Counts objects asynchronously using the FetchRequestBuilder
    /// - Parameter builder: The fetch request builder
    /// - Returns: Count of matching objects
    /// - Throws: Core Data errors
    func executeCount(_ builder: FetchRequestBuilder<ManagedObject>) async throws -> Int {
        return try await performBackgroundTask { context in
            let request = builder.returningCount().build()
            return try context.count(for: request)
        }
    }
}