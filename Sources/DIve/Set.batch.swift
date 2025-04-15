// Created by Alex Balobanov

extension Set where Element: AbstractDependency {
    /// Splits a dependency graph into an array of sets (batches) that need to be loaded in the right order.
    /// Each set contains dependencies that can be loaded simultaneously.
    /// - Returns: an ordered array of sets.
    func batch() throws -> [Self] {
        var loaded: Set<DependencyId> = []
        var remainder = self
        var result: [Self] = []

        while !remainder.isEmpty {
            let scheduled = remainder.filter {
                $0.dependencies.isEmpty || $0.dependencies.isSubset(of: loaded)
            }

            if scheduled.isEmpty {
                throw LoaderError.notDAG
            }

            result.append(scheduled)

            let scheduledIds = scheduled.map { $0.id }
            loaded = loaded.union(scheduledIds)
            remainder = remainder.subtracting(scheduled)
        }
        return result
    }
}
