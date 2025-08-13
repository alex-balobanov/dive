// Created by Alex Balobanov

/// The object resolves a given dependency graph to an ordered sequence of dependencies arranged in the right order to load.
public struct DependencySequence<T: SyncInjecting> {
    public typealias DependencyType = Dependency<T>
    private let sequence: [DependencyType]

    public init(dependencies: Set<DependencyType>) throws {
        sequence = try dependencies.batch().flatMap { $0 }
    }
}

extension DependencySequence: Sequence {
    public func makeIterator() -> IndexingIterator<Array<DependencyType>> {
        sequence.makeIterator()
    }
}
