// Created by Alex Balobanov

/// The implementation of ``AbstractPool`` protocol.
public struct Pool {
    private let defaults: [ObjectIdentifier: Any]
    private let overrides: [AnyKeyPath: Any]
}

extension Pool {
    public init() {
        self.init(defaults: [:], overrides: [:])
    }
}

extension Pool: AbstractPool {
    public subscript<T>(_ type: T.Type) -> T {
        do {
            return try find(type)
        } catch {
            fatalErrorHandler(error)
        }
    }

    public subscript<R, V>(_ keyPath: KeyPath<R, V>) -> V {
        do {
            return try find(keyPath)
        } catch {
            fatalErrorHandler(error)
        }
    }

    public func find<T>(_ type: T.Type) throws -> T {
        let id = ObjectIdentifier(type)

        if let index = defaults.index(forKey: id),
           let object = defaults.values[index] as? T {
            return object
        }

        if let index = defaults.values.firstIndex(where: { $0 is T }),
           let object = defaults.values[index] as? T {
            return object
        }

        throw PoolError.objectNotFoundForType(type)
    }

    public func find<R, V>(_ keyPath: KeyPath<R, V>) throws -> V {
        if let index = overrides.index(forKey: keyPath),
           let object = overrides.values[index] as? V {
            return object
        }

        throw PoolError.objectNotFoundForKeyPath(keyPath)
    }

    public func appending<T>(_ v: T) -> Self {
        let id = ObjectIdentifier(type(of: v))
        var defaults = self.defaults
        defaults[id] = v

        return .init(
            defaults: defaults,
            overrides: overrides
        )
    }

    public func appending<R, V>(_ keyPath: KeyPath<R, V>, _ v: V) -> Self {
        var overrides = self.overrides
        overrides[keyPath] = v

        return .init(
            defaults: defaults,
            overrides: overrides
        )
    }

    public func appending(_ pool: Self) -> Self {
        var defaults = self.defaults
        pool.defaults.forEach { k, v in
            defaults[k] = v
        }

        var overrides = self.overrides
        pool.overrides.forEach { k, v in
            overrides[k] = v
        }

        return .init(
            defaults: defaults,
            overrides: overrides
        )
    }
}
