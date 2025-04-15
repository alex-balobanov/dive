// Created by Alex Balobanov

/// Dependency identifier.
public struct DependencyId {
    private let value: String
}

extension DependencyId: ExpressibleByStringLiteral {
    /// `DependencyId` type can be initialized with a string literal.
    /// - Parameter value: a unique string.
    public init(stringLiteral value: String) {
        self.init(value: value)
    }
}

extension DependencyId: CustomStringConvertible {
    public var description: String {
        value
    }
}

extension DependencyId: Hashable {}
