// Created by Alex Balobanov

/// The  implementation of ``AsyncInjecting`` protocol.
public struct AsyncInjector<T: AbstractPool> {
    let injector: @Sendable (T) async throws -> T

    /// The initializer that accept an injection closure.
    /// - Parameter injector: the actual closure to inject a dependency.
    public init(injector: @escaping @Sendable (T) async throws -> T) {
        self.injector = injector
    }
}

extension AsyncInjector: Sendable {}

extension AsyncInjector: AsyncInjecting {
    public func inject(_ pool: T) async throws -> T {
        try await injector(pool)
    }
}
