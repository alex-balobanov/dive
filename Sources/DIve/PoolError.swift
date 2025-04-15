// Created by Alex Balobanov

import Foundation

/// Errors of ``Pool`` object.
public enum PoolError {
    case objectNotFoundForKeyPath(AnyKeyPath)
    case objectNotFoundForType(Any.Type)
}

extension PoolError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .objectNotFoundForKeyPath(let keyPath):
            return "Object not found for key path: \(keyPath)"
        case .objectNotFoundForType(let type):
            return "Object not found for type: \(type)"
        }
    }
}

extension PoolError: Error {}
