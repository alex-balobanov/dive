// Created by Alex Balobanov

import Foundation

/// Errors of ``Injected`` object.
public enum InjectedError {
    case objectNotFound(AnyKeyPath, Any.Type)
}

extension InjectedError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .objectNotFound(keyPath, type):
            return "Object not found for key path \(keyPath) or type \(type)."
        }
    }
}

extension InjectedError: Error {}
