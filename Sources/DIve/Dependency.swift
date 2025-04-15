// Created by Alex Balobanov

/// The  implementation of ``AbstractDependency`` protocol.
public struct Dependency<T: Injecting> {
    public let id: DependencyId
    public let dependencies: Set<DependencyId>
    public let injector: T

    public init(id: DependencyId, dependencies: Set<DependencyId>, injector: T) {
        self.id = id
        self.dependencies = dependencies
        self.injector = injector
    }
}

extension Dependency: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension Dependency: AbstractDependency {}
