// Created by Alex Balobanov

/// Errors of ``SerialLoader`` and ``ConcurrentLoader`` objects.
public enum LoaderError {
    case notDAG
}

extension LoaderError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notDAG:
            return "Not a directed acyclic graph"
        }
    }
}

extension LoaderError: Error {}
