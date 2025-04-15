// Created by Alex Balobanov

/// Provides a pool. Used along with ``Injected`` property wrapper to access objects in the pool.
public protocol PoolProviding: AnyObject {
    /// The type of the pool.
    associatedtype PoolType: AbstractPool

    /// The pool that provides objects.
    var pool: PoolType { get }
}
