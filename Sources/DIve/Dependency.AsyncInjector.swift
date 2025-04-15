// Created by Alex Balobanov

/// A typealias for ``Dependency`` object with ``AsyncInjector``.
public typealias AsyncInjectingDependency<T: AbstractPool> = Dependency<AsyncInjector<T>>

public extension AsyncInjectingDependency<Pool> {
    /// A helper function to create ``Dependency`` object.
    /// - Parameters:
    ///   - id: a dependency id.
    ///   - dependencies: a set of dependencies that the current dependency depends on.
    ///   - injector: an injection closure.
    /// - Returns: an instance of ``Dependency`` object.
    static func dependency(
        id: DependencyId,
        dependencies: Set<DependencyId>,
        injector: @escaping (Pool) async throws -> Pool
    ) -> Self {
        .init(id: id, dependencies: dependencies, injector: .init(injector: injector))
    }
}
