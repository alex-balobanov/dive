// Created by Alex Balobanov

/// An abstract protocol for injecting dependencies.
public protocol Injecting {}

/// Asynchronous injecting dependencies.
/// Used to inject a single dependency or logically coupled dependencies to a pool.
public protocol AsyncInjecting: Injecting {
    /// The type of the pool.
    associatedtype PoolType: AbstractPool

    /// Asynchronously injects dependencies into the specified pool and returns a new pool.
    /// - Parameter pool: an initial  pool.
    /// - Returns: a new pool.
    func inject(_ pool: PoolType) async throws -> PoolType
}

/// Synchronous injecting dependencies.
/// Used to inject a single dependency or logically coupled dependencies to a pool.
public protocol SyncInjecting: Injecting {
    /// The type of the pool.
    associatedtype PoolType: AbstractPool

    /// Synchronously injects dependencies into the specified pool and returns a new pool.
    /// - Parameter pool: an initial  pool.
    /// - Returns: a new pool.
    func inject(_ pool: PoolType) throws -> PoolType
}
