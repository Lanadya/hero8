import CoreData

// MARK: - Global Helper Functions

/// Global helper function to create a FetchRequestBuilder with an entity type
/// - Parameter entityType: The entity type
/// - Returns: A configured FetchRequestBuilder
public func buildFetchRequest<T: NSManagedObject>(_ entityType: T.Type) -> FetchRequestBuilder<T> {
    return FetchRequestBuilder<T>(entityType: entityType)
}

/// Global helper function to create a FetchRequestBuilder with an entity name
/// - Parameter entityName: The entity name
/// - Returns: A configured FetchRequestBuilder
public func buildFetchRequest<T: NSManagedObject>(entityName: String) -> FetchRequestBuilder<T> {
    return FetchRequestBuilder<T>(entityName: entityName)
}

// MARK: - NSManagedObjectContext Extensions

extension NSManagedObjectContext {
    /// Helper method to fetch objects using typesafe FetchRequestBuilder
    /// - Parameter builder: The FetchRequestBuilder to use
    /// - Returns: The fetched objects
    /// - Throws: Core Data fetch errors
    public func fetch<T: NSManagedObject>(_ builder: FetchRequestBuilder<T>) throws -> [T] {
        return try fetch(builder.build())
    }
    
    /// Helper method to count objects using typesafe FetchRequestBuilder
    /// - Parameter builder: The FetchRequestBuilder to use
    /// - Returns: The count of objects
    /// - Throws: Core Data fetch errors
    public func count<T: NSManagedObject>(for builder: FetchRequestBuilder<T>) throws -> Int {
        let request = builder.returningCount().build()
        return try count(for: request)
    }
    
    /// Helper method to fetch objects asynchronously using typesafe FetchRequestBuilder
    /// - Parameter builder: The FetchRequestBuilder to use
    /// - Returns: The fetched objects
    /// - Throws: Core Data fetch errors
    public func fetch<T: NSManagedObject>(_ builder: FetchRequestBuilder<T>) async throws -> [T] {
        let request = builder.build()
        
        return try await withCheckedThrowingContinuation { continuation in
            perform {
                do {
                    let results = try self.fetch(request)
                    continuation.resume(returning: results)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Helper method to count objects asynchronously using typesafe FetchRequestBuilder
    /// - Parameter builder: The FetchRequestBuilder to use
    /// - Returns: The count of objects
    /// - Throws: Core Data fetch errors
    public func count<T: NSManagedObject>(for builder: FetchRequestBuilder<T>) async throws -> Int {
        let request = builder.returningCount().build()
        
        return try await withCheckedThrowingContinuation { continuation in
            perform {
                do {
                    let count = try self.count(for: request)
                    continuation.resume(returning: count)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}