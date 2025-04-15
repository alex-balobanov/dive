// Created by Alex Balobanov

import Testing
import DIve

@Suite("SerialLoader Tests")
struct SerialLoaderTests {
    @Test("The serial loader loads dependencies")
    func loadNormalDependencies() throws {
        let loader = SerialLoader(dependencies: .normal)
        let pool = try loader.load(Pool())
        #expect(try pool.valid())
    }

    @Test("The serial loader throws an error when loads cyclic dependencies")
    func loadCyclicDependencies() {
        let loader = SerialLoader(dependencies: .cyclic)
        #expect(throws: LoaderError.notDAG) {
            _ = try loader.load(Pool())
        }
    }

    @Test("The serial loader propages an error that was thrown by a dependency")
    func loadThrowingDependency() {
        let loader = SerialLoader(dependencies: .throwing)
        #expect(throws: TestError.self) {
            _ = try loader.load(Pool())
        }
    }
}

private extension Set<SyncInjectingDependency<Pool>> {
    static let normal: Self = [
        .dependency(id: .a, dependencies: [.b], injector: { pool in
            pool.appending("a" + pool[String.self])
        }),
        .dependency(id: .b, dependencies: [.c], injector: { pool in
            pool.appending("b" + pool[String.self])
        }),
        .dependency(id: .c, dependencies: [], injector: { pool in
            pool.appending("c")
        }),
    ]

    static let cyclic: Self = [
        .dependency(id: .a, dependencies: [.b], injector: { $0 }),
        .dependency(id: .b, dependencies: [.a], injector: { $0 }),
    ]

    static let throwing: Self = [
        .dependency(id: .a, dependencies: [], injector: { _ in throw TestError() }),
    ]
}

private extension Pool {
    func valid() throws -> Bool {
        self[String.self] == "abc"
    }
}

private extension DependencyId {
    static let a: Self = "a"
    static let b: Self = "b"
    static let c: Self = "c"
}

private struct TestError: Error {}
