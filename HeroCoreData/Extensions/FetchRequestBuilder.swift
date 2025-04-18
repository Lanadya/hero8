import Foundation
import CoreData

// MARK: - FetchRequestBuilder

/// A wrapper class to build NSFetchRequest with a fluent interface
public class FetchRequestBuilder<Entity: NSManagedObject> {
    private let fetchRequest: NSFetchRequest<Entity>
    
    /// Initialize with an entity name
    /// - Parameter entityName: The name of the entity
    public init(entityName: String) {
        self.fetchRequest = NSFetchRequest<Entity>(entityName: entityName)
    }
    
    /// Initialize with an entity type
    /// - Parameter entityType: The entity type
    public init(entityType: Entity.Type) {
        self.fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: entityType))
    }
    
    /// Get the built fetch request
    /// - Returns: The configured NSFetchRequest
    public func build() -> NSFetchRequest<Entity> {
        return fetchRequest
    }
    
    /// Adds a predicate to filter the fetch request
    /// - Parameter predicate: The predicate to add
    /// - Returns: Self for chaining
    @discardableResult
    public func filtering(with predicate: NSPredicate) -> FetchRequestBuilder<Entity> {
        fetchRequest.predicate = predicate
        return self
    }
    
    /// Adds a predicate with a format string to filter the fetch request
    /// - Parameters:
    ///   - format: The format string for the predicate
    ///   - args: The arguments for the format string
    /// - Returns: Self for chaining
    @discardableResult
    public func filtering(format: String, _ args: Any...) -> FetchRequestBuilder<Entity> {
        return filtering(with: NSPredicate(format: format, argumentArray: args))
    }
    
    /// Combines multiple predicates with AND and adds them to the fetch request
    /// - Parameter predicates: The predicates to combine
    /// - Returns: Self for chaining
    @discardableResult
    public func filtering(with predicates: [NSPredicate]) -> FetchRequestBuilder<Entity> {
        if predicates.isEmpty { return self }
        if predicates.count == 1 { return filtering(with: predicates[0]) }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return filtering(with: compoundPredicate)
    }
    
    /// Adds a sort descriptor to the fetch request
    /// - Parameters:
    ///   - key: The key to sort by
    ///   - ascending: Whether to sort in ascending order
    /// - Returns: Self for chaining
    @discardableResult
    public func sorting(by key: String, ascending: Bool = true) -> FetchRequestBuilder<Entity> {
        let sortDescriptor = NSSortDescriptor(key: key, ascending: ascending)
        if fetchRequest.sortDescriptors == nil {
            fetchRequest.sortDescriptors = [sortDescriptor]
        } else {
            fetchRequest.sortDescriptors?.append(sortDescriptor)
        }
        return self
    }
    
    /// Adds multiple sort descriptors to the fetch request
    /// - Parameter sortDescriptors: The sort descriptors to add
    /// - Returns: Self for chaining
    @discardableResult
    public func sorting(with sortDescriptors: [NSSortDescriptor]) -> FetchRequestBuilder<Entity> {
        if fetchRequest.sortDescriptors == nil {
            fetchRequest.sortDescriptors = sortDescriptors
        } else {
            fetchRequest.sortDescriptors?.append(contentsOf: sortDescriptors)
        }
        return self
    }
    
    /// Sets a fetch limit on the request
    /// - Parameter limit: The maximum number of results to return
    /// - Returns: Self for chaining
    @discardableResult
    public func limiting(to limit: Int) -> FetchRequestBuilder<Entity> {
        fetchRequest.fetchLimit = limit
        return self
    }
    
    /// Sets an offset for the fetch request
    /// - Parameter offset: The number of results to skip
    /// - Returns: Self for chaining
    @discardableResult
    public func skipping(_ offset: Int) -> FetchRequestBuilder<Entity> {
        fetchRequest.fetchOffset = offset
        return self
    }
    
    /// Sets the fetch batch size
    /// - Parameter size: The batch size for fetching
    /// - Returns: Self for chaining
    @discardableResult
    public func batching(size: Int) -> FetchRequestBuilder<Entity> {
        fetchRequest.fetchBatchSize = size
        return self
    }
    
    /// Includes pending changes in the fetch results
    /// - Returns: Self for chaining
    @discardableResult
    public func includingPendingChanges() -> FetchRequestBuilder<Entity> {
        fetchRequest.includesPendingChanges = true
        return self
    }
    
    /// Sets the result type for the fetch request
    /// - Parameter type: The result type
    /// - Returns: Self for chaining
    @discardableResult
    public func resultType(_ type: NSFetchRequestResultType) -> FetchRequestBuilder<Entity> {
        fetchRequest.resultType = type
        return self
    }
    
    /// Configures the fetch request to return distinct results
    /// - Parameter propertiesToFetch: The properties to fetch
    /// - Returns: Self for chaining
    @discardableResult
    public func returningDistinct(properties propertiesToFetch: [String]) -> FetchRequestBuilder<Entity> {
        fetchRequest.propertiesToFetch = propertiesToFetch
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = .dictionaryResultType
        return self
    }
    
    /// Configures the fetch request to return only the object IDs
    /// - Returns: Self for chaining
    @discardableResult
    public func returningObjectIDs() -> FetchRequestBuilder<Entity> {
        fetchRequest.resultType = .managedObjectIDResultType
        return self
    }
    
    /// Configures the fetch request to return only the count
    /// - Returns: Self for chaining
    @discardableResult
    public func returningCount() -> FetchRequestBuilder<Entity> {
        fetchRequest.resultType = .countResultType
        return self
    }
    
    /// Configures the fetch request to return dictionaries
    /// - Returns: Self for chaining
    @discardableResult
    public func returningDictionaries() -> FetchRequestBuilder<Entity> {
        fetchRequest.resultType = .dictionaryResultType
        return self
    }
    
    /// Sets the properties to fetch
    /// - Parameter properties: The properties to fetch
    /// - Returns: Self for chaining
    @discardableResult
    public func fetching(properties: [String]) -> FetchRequestBuilder<Entity> {
        fetchRequest.propertiesToFetch = properties
        return self
    }
    
    /// Sets the relationships to prefetch
    /// - Parameter relationships: The relationships to prefetch
    /// - Returns: Self for chaining
    @discardableResult
    public func prefetching(relationships: [String]) -> FetchRequestBuilder<Entity> {
        fetchRequest.relationshipKeyPathsForPrefetching = relationships
        return self
    }
}