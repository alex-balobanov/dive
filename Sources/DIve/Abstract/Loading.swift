// Created by Alex Balobanov

/// Concurrent loading events.
public protocol ConcurrentLoadingEventHandling {
    /// This function calls by a concurrent loader before loading the dependency with `dependencyId`.
    /// - Parameter dependencyId: a unique dependency identifier.
    func willLoadDependency(_ dependencyId: DependencyId) async

    /// This function calls by a concurrent loader after loading the dependency with `dependencyId`.
    /// - Parameter dependencyId: a unique dependency identifier.
    func didLoadDependency(_ dependencyId: DependencyId) async
}

/// Concurrent loading dependencies.
/// Used to load multiple dependencies (a dependency graph) to a pool via ``AsyncInjecting``.
public protocol ConcurrentLoading {
    /// The type of the pool.
    associatedtype PoolType: AbstractPool

    /// Asynchronously loads dependencies into the specified pool and returns a new pool.
    /// - Parameter pool: a pool.
    /// - Returns: a new pool.
    func load(_ pool: PoolType) async throws -> PoolType

    /// Asynchronously loads dependencies into the specified pool and returns a new pool.
    /// Emits loading progress events via ``ConcurrentLoadingEventHandling``.
    /// - Parameters:
    ///   - pool: an initial  pool.
    ///   - handler: a loading events handler.
    /// - Returns: a new pool.
    func load(_ pool: PoolType, _ handler: ConcurrentLoadingEventHandling) async throws -> PoolType
}

/// Serial loading dependencies.
/// Used to load multiple dependencies (a dependency graph) to a pool via ``SyncInjecting``.
public protocol SerialLoading {
    /// The type of the pool.
    associatedtype PoolType: AbstractPool

    /// Synchronously loads dependencies into the specified pool and returns a new pool.
    /// - Parameter pool: an initial  pool.
    /// - Returns: a new pool.
    func load(_ pool: PoolType) throws -> PoolType
}
