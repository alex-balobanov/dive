# DIve 

A minimalistic Swift dependency injection framework.

## Quick Introduction

`Pool` - an immutable storage for dependencies.

`@Injected` - a property wrapper to access dependencies in pools.  

`SerialLoader` - a serial loader to fill out pools with dependencies in synchronous way. 

`ConcurrentLoader` - a concurrent loader to fill out pools with dependencies in asynchronous way.

### A common use-case of the framework

- create a pool
- inject dependencies to the pool manually or by using the loaders
- pass the pool over to an object
- use the property wrapper to access injected dependencies
- profit

## Injecting a dependency by type

```swift
let pool = Pool()
    .appending(<dependency> [as <type>])
```

## Injecting a dependency by key path

```swift
let pool = Pool()
    .appending(<key path>, <dependency>)
```

## Using `@Injected` property wrapper

```swift
class <class>: Injectee<Pool> {
    @Injected private var <dependency>: <type> [= <default value>]
}
```

### Priority

- highest: a dependency injected by keypath
- a dependency injected by type
- lowest: default value

### An example

```swift
class RandomNumber: Injectee<Pool> {
    @Injected private var generator: RandomNumberGenerator

    func generate(in range: Range<UInt64>) -> UInt64 {
        .random(in: range, using: &generator)
    }
}

let pool = Pool().appending(SystemRandomNumberGenerator())
let randomNumber = RandomNumber(pool: pool)
print(randomNumber.generate(in: 0..<10))
```

## Using a custom fatal error handler.

```swift
public protocol FatalErrorHandling {
    func fatalErrorHandler(_ error: Error) -> Never
}
```

### An example

```swift
struct FatalErrorHandler: FatalErrorHandling {
    func fatalErrorHandler(_ error: Error) -> Never {
        print("A fatal error occurred: \(error)")
        fatalError()
    }
}

let pool = Pool().appending(FatalErrorHandler() as FatalErrorHandling)
let randomNumber = RandomNumber(pool: pool)
print(randomNumber.generate(in: 0..<10))
```

## Using loaders to fill out pools

### `SerialLoader`

```swift
let loader = SerialLoader<SyncInjector<Pool>>(dependencies: <dependencies>)
let pool = try loader.load(Pool())
```

### `ConcurrentLoader` 

```swift
let loader = ConcurrentLoader<AsyncInjector<Pool>>(dependencies: <dependencies>)
let pool = try await loader.load(Pool())
```

### `ConcurrentLoader` + loading events handler 

```swift
let handler = ConcurrentLoadingEventHandler()
let loader = ConcurrentLoader<AsyncInjector<Pool>>(dependencies: <dependencies>)
let pool = try await loader.load(Pool(), handler)
```

### An example

```swift
let loader = ConcurrentLoader<AsyncInjector<Pool>>(dependencies: [
    .dependency(id: .randomNumberGenerator, dependencies: []) { pool in
        pool.appending(SystemRandomNumberGenerator())
    }
])
let pool = try await loader.load(Pool())
let randomNumber = RandomNumber(pool: pool)
print(randomNumber.generate(in: 0..<10))
```
