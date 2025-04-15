// Created by Alex Balobanov

/// Implements ``PoolProviding`` protocol and provides the initializer to pass a pool to the object.
/// Dependencies can be injected to this object via the specifid pool and accessed via ``Injected`` property wrapper.
open class Injectee<T: AbstractPool> {
    public let pool: T

    public init(pool: T) {
        self.pool = pool
    }
}

extension Injectee: PoolProviding {}
