// Created by Alex Balobanov

/// The  implementation of ``SerialLoading`` protocol.
public struct SerialLoader<T: SyncInjecting> {
    public typealias DependencyType = Dependency<T>
    private let dependencies: Set<DependencyType>

    public init(dependencies: Set<DependencyType>) {
        self.dependencies = dependencies
    }
}

extension SerialLoader: SerialLoading {
    public func load(_ pool: T.PoolType) throws -> T.PoolType {
        let dependencySequence = try DependencySequence(dependencies: dependencies)
        return try dependencySequence.reduce(pool, { pool, dependency in
            pool.appending(try dependency.injector.inject(pool))
        })
    }
}
