# DIve 

DIve is a minimalistic Swift dependency injection framework.

Please check out this article for the details: [Introduction to DIve](https://balobanov.com/articles/dive-introduction/)

## Installation

To add the framework to your Xcode project, select `File > Add Package Dependency` and enter `https://github.com/alex-balobanov/dive` as source control repository URL.

To add the framework as a dependency of another Swift package, update the corresponding `Package.swift` file.

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/alex-balobanov/dive", from: "2.3.0"),
    ],
    ...
)
```

## Building a pool manually

`Pool` - an immutable storage for dependencies.

### Appending a dependency by type

```swift
let pool = Pool()
    .appending(<dependency> [as <type>])
```

### Appending a dependency by key path

```swift
let pool = Pool()
    .appending(<key path>, <dependency>)
```

### Using `@Injected` property wrapper

`@Injected` - a property wrapper to access dependencies in pools.

```swift
class <class>: Injectee<Pool> {
    @Injected private var <dependency>: <type> [= <default value>]
}
```

### Priority

- highest: a dependency injected by keypath
- a dependency injected by type
- lowest: default value

## Using loaders

### SerialLoader

`SerialLoader` - a serial loader to fill out pools with dependencies in synchronous way.

```swift
let loader = SerialLoader(dependencies: [
    <Dependency objects>
])
let pool = try loader.load(Pool())
```

### ConcurrentLoader

`ConcurrentLoader` - a concurrent loader to fill out pools with dependencies in asynchronous way.

```swift
let loader = ConcurrentLoader(dependencies: <dependencies>)
let pool = try await loader.load(Pool())
```

### ConcurrentLoader + loading events handler

```swift
actor ConcurrentLoadingEventHandler: ConcurrentLoadingEventHandling { < impl > }
let handler = ConcurrentLoadingEventHandler()
let loader = ConcurrentLoader(dependencies: [
    <Dependency objects>
])
let pool = try await loader.load(Pool(), handler)
```

## Appending a custom fatal error handler

```swift
struct FatalErrorHandler: FatalErrorHandling {
    func fatalErrorHandler(_ error: Error) -> Never {
        <custom logic here>
        fatalError()
    }
}

let pool = Pool()
    .appending(FatalErrorHandler())
```
