// Created by Alex Balobanov

/// The  implementation of ``SyncInjecting`` protocol.
public struct SyncInjector<T: AbstractPool> {
    let injector: (T) throws -> T

    /// The initializer that accept an injection closure.
    /// - Parameter injector: the actual closure to inject a dependency.
    public init(injector: @escaping (T) throws -> T) {
        self.injector = injector
    }
}

extension SyncInjector: SyncInjecting {
    public func inject(_ pool: T) throws -> T {
        try injector(pool)
    }
}
