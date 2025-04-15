// Created by Alex Balobanov

/// The protocol describes a dependency, an entity that depends on other ones.
public protocol AbstractDependency {
    /// A unique identifier of the dependency.
    var id: DependencyId { get }

    /// The dependencies that the current entity depends on.
    var dependencies: Set<DependencyId> { get }
}
