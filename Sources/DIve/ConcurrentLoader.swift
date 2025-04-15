// Created by Alex Balobanov

import Foundation

/// The  implementation of ``ConcurrentLoading`` protocol.
public struct ConcurrentLoader<T: AsyncInjecting> {
    public typealias DependencyType = Dependency<T>
    private let dependencies: Set<DependencyType>

    public init(dependencies: Set<DependencyType>) {
        self.dependencies = dependencies
    }
}

extension ConcurrentLoader: ConcurrentLoading {
    public func load(_ pool: T.PoolType) async throws -> T.PoolType {
        try await load(pool) { pool, dependency in
            try await dependency.injector.inject(pool)
        }
    }

    public func load(
        _ pool: PoolType,
        _ handler: ConcurrentLoadingEventHandling
    ) async throws -> PoolType {
        try await load(pool) { pool, dependency in
            await handler.willLoadDependency(dependency.id)
            let result = try await dependency.injector.inject(pool)
            await handler.didLoadDependency(dependency.id)
            return result
        }
    }
}

private extension ConcurrentLoader {
    typealias DependencyLoaderClosure = (T.PoolType, DependencyType) async throws -> T.PoolType

    func load(
        _ pool: T.PoolType,
        _ loader: @escaping DependencyLoaderClosure
    ) async throws -> T.PoolType {
        let batches = try dependencies.batch()
        var pool = pool
        for batch in batches {
            pool = try await withThrowingTaskGroup(of: T.PoolType.self) { group in
                batch.forEach { dependency in
                    group.addTask(priority: .userInitiated) {
                        try await loader(pool, dependency)
                    }
                }
                return try await group.reduce(pool, { pool, newpool in pool.appending(newpool) })
            }
        }
        return pool
    }
}
