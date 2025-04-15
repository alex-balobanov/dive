//  Created by Alex Balobanov

import Testing
import DIve

@Suite("ConcurrentLoader Tests")
struct ConcurrentLoaderTests {
    @Test("The concurrent loader loads dependencies")
    func loadNormalDependencies() async throws {
        let loader = ConcurrentLoader(dependencies: .normal)
        let pool = try await loader.load(Pool())
        #expect(try pool.valid())
    }

    @Test("The concurrent loader loads dependencies and reports progress")
    func loadNormalDependenciesWithHandler() async throws {
        let handler = ConcurrentLoadingEventHandler()
        let loader = ConcurrentLoader(dependencies: .normal)
        let pool = try await loader.load(Pool(), handler)
        #expect(try pool.valid())
        await #expect(handler.willLoad == ["c", "b", "a"])
        await #expect(handler.didLoad == ["c", "b", "a"])
    }

    @Test("The concurrent loader throws an error when loads cyclic dependencies")
    func loadCyclicDependencies() async throws {
        let loader = ConcurrentLoader(dependencies: .cyclic)
        await #expect(throws: LoaderError.notDAG) {
            _ = try await loader.load(Pool())
        }
    }

    @Test("The concurrent loader propages an error that was thrown by a dependency")
    func loadThrowingDependency() async throws {
        let loader = ConcurrentLoader(dependencies: .throwing)
        await #expect(throws: TestError.self) {
            _ = try await loader.load(Pool())
        }
    }
}

private extension ConcurrentLoaderTests {
    actor ConcurrentLoadingEventHandler: ConcurrentLoadingEventHandling {
        private(set) var willLoad: [String] = []
        private(set) var didLoad: [String] = []

        func willLoadDependency(_ dependencyId: DependencyId) async {
            willLoad.append(dependencyId.description)
        }

        func didLoadDependency(_ dependencyId: DependencyId) async {
            didLoad.append(dependencyId.description)
        }
    }
}

private extension Set<AsyncInjectingDependency<Pool>> {
    static let normal: Self = [
        .dependency(id: .a, dependencies: [.b], injector: { pool in
            pool.appending(\TestObject.abc, "a" + pool[\TestObject.bc])
        }),
        .dependency(id: .b, dependencies: [.c], injector: { pool in
            pool.appending(\TestObject.bc, "b" + pool[\TestObject.c])
        }),
        .dependency(id: .c, dependencies: [], injector: { pool in
            pool.appending(\TestObject.c, "c")
        }),
    ]

    static let cyclic: Self = [
        .dependency(id: .a, dependencies: [.b], injector: { $0 }),
        .dependency(id: .b, dependencies: [.a], injector: { $0 }),
    ]

    static let throwing: Self = [
        .dependency(id: .a, dependencies: [], injector: { _ in throw TestError() })
    ]
}

private extension Pool {
    func valid() throws -> Bool {
        let testObject = TestObject(pool: self)
        return testObject.abc == "abc" && testObject.bc == "bc" && testObject.c == "c"
    }
}

private extension DependencyId {
    static let a: Self = "a"
    static let b: Self = "b"
    static let c: Self = "c"
}

private class TestObject: Injectee<Pool> {
    @Injected var abc: String
    @Injected var bc: String
    @Injected var c: String
}

private struct TestError: Error {}
