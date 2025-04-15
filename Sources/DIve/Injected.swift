// Created by Alex Balobanov

/// The property wrapper to access elements in pools.
/// This is the recommended way to deal with retrieving objects.
@propertyWrapper
public struct Injected<Value> {
    private var `default`: Value?

    public static subscript<T: PoolProviding>(
        _enclosingInstance instance: T,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<T, Self>
    ) -> Value {
        get {
            let injected = instance[keyPath: storageKeyPath]

            if let value = try? instance.pool.find(wrappedKeyPath) {
                return value
            }

            if let value = try? instance.pool.find(Value.self) {
                return value
            }

            if let value = injected.default {
                return value
            }

            instance.pool.fatalErrorHandler(
                InjectedError.objectNotFound(wrappedKeyPath, Value.self)
            )
        }
        set {
            instance[keyPath: storageKeyPath].default = newValue
        }
    }

    @available(*, unavailable)
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    public init(wrappedValue: Value) {
        self.default = wrappedValue
    }

    public init() {
        self.default = nil
    }
}
