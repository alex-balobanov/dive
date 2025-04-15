// Created by Alex Balobanov

/// The protocol describes a pool, an immutable storage whose elements are key-value pairs.
/// A value can be retrieved from a pool by a type or a key path.
public protocol AbstractPool {
    /// Accesses the element by the specified type.
    /// - Parameter type: a type of the element.
    /// - Returns: Returns the element or call the fatal error handler ``FatalErrorHandling/fatalErrorHandler(_:)``.
    subscript<T>(_ type: T.Type) -> T { get }

    /// Accesses the element by the specified key path.
    /// - Parameter keyPath: a key path for the element.
    /// - Returns: Returns the element or call the fatal error handler ``FatalErrorHandling/fatalErrorHandler(_:)``.
    subscript<R, V>(_ keyPath: KeyPath<R, V>) -> V { get }

    /// Finds an element by the specified type.
    /// - Parameter type: a type of the element.
    /// - Returns: Returns the element or throws an error.
    func find<T>(_ type: T.Type) throws -> T

    /// Finds an element by the specified key path.
    /// - Parameter keyPath: a key path for the element.
    /// - Returns: Returns the element or throws an error.
    func find<R, V>(_ keyPath: KeyPath<R, V>) throws -> V

    /// Returns a new pool by appending the specified element with the current pool by using a type.
    /// - Parameter v: the new element.
    /// - Returns: a new pool.
    func appending<T>(_ v: T) -> Self

    /// Returns a new pool by appending the specified element with the current pool by using a key path.
    /// - Parameters:
    ///   - keyPath: a key path for the new element.
    ///   - v: the new element.
    /// - Returns: a new pool.
    func appending<R, V>(_ keyPath: KeyPath<R, V>, _ v: V) -> Self

    /// Returns a new pool by appending the specified pool with the current one.
    /// All existing elements in the current pool will be updated with values from a new one.
    /// - Parameter pool: the pool to append.
    /// - Returns: a new pool.
    func appending(_ pool: Self) -> Self
}
