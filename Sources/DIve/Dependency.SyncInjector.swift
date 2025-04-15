// Created by Alex Balobanov

/// A typealias for ``Dependency`` object with ``SyncInjector``.
public typealias SyncInjectingDependency<T: AbstractPool> = Dependency<SyncInjector<T>>

public extension SyncInjectingDependency<Pool> {
    /// A helper function to create ``Dependency`` object.
    /// - Parameters:
    ///   - id: a dependency id.
    ///   - dependencies: a set of dependencies that the current dependency depends on.
    ///   - injector: an injection closure.
    /// - Returns: an instance of ``Dependency`` object.
    static func dependency(
        id: DependencyId,
        dependencies: Set<DependencyId>,
        injector: @escaping (Pool) throws -> Pool
    ) -> Self {
        .init(id: id, dependencies: dependencies, injector: .init(injector: injector))
    }
}
