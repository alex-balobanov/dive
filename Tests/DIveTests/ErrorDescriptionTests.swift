//  Created by Alex Balobanov

import Testing
import DIve

@Suite("Errors Descriptions Tests")
struct ErrorDescriptionTests {
    @Test("Check LoaderError.notDAG description")
    func notDAG() async throws {
        #expect(String(describing: LoaderError.notDAG) == "Not a directed acyclic graph")
    }

    @Test("Check PoolError.objectNotFoundForType description", arguments: [Int.self, String.self])
    func objectNotFoundForType(_ type: Any.Type) async throws {
        let expectedDescription = "Object not found for type: \(type)"
        #expect(String(describing: PoolError.objectNotFoundForType(type)) == expectedDescription)
    }

    @Test("Check PoolError.objectNotFoundForKeyPath description", arguments: [\TestObject.int, \TestObject.string])
    func objectNotFoundForKeyPath(_ keyPath: AnyKeyPath) async throws {
        let expectedDescription = "Object not found for key path: \(keyPath)"
        #expect(String(describing: PoolError.objectNotFoundForKeyPath(keyPath)) == expectedDescription)
    }

    @Test("Check InjectedError.objectNotFound description", arguments: zip([\TestObject.int, \TestObject.string], [Int.self, String.self]))
    func objectNotFound(_ keyPath: AnyKeyPath, _ type: Any.Type) async throws {
        let expectedDescription = "Object not found for key path \(keyPath) or type \(type)."
        #expect(String(describing: InjectedError.objectNotFound(keyPath, type)) == expectedDescription)
    }
}

private extension ErrorDescriptionTests {
    class TestObject: Injectee<Pool> {
        @Injected var int: Int
        @Injected var string: String
    }
}
