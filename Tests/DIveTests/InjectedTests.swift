// Created by Alex Balobanov

import XCTest
import DIve

final class InjectedTests: XCTestCase {
    func test_givenEmptyPool_whenAccessInjectedObject_thenFatalError() {
        let emptyPool = Pool()

        let keyPath = \TestObject<String, Pool>.object
        let type = String.self
        let expectedError = InjectedError.objectNotFound(keyPath, type)

        let error = waitForFatalError(pool: emptyPool) { pool in
            let object = TestObject<String, Pool>(pool: pool)
            _ = object.object
        }
        XCTAssertEqual(error as? NSError, expectedError as NSError)
    }

    func test_givenPoolWithNilObject_whenAccessOptionalInjectedObject_thenReturnsNil() {
        let string: String? = nil
        let pool = Pool().appending(string)
        let object = TestObject<String?, Pool>(pool: pool)
        XCTAssertNil(object.object)
    }

    func test_givenEmptyPool_whenAccessDefaultedInjectedObject_thenReturnsDefaultValue() {
        let object = TestObject<String, Pool>(pool: Pool(), default: .string1)
        XCTAssertEqual(object.object, .string1)
    }

    func test_givenEmptyPool_whenAccessExplicitlyDefaultedValue_thenReturnsDefaultValue() {
        let object = TestObjectWithDefaultValue(pool: Pool())
        XCTAssertEqual(object.object, .defaultValue)
    }

    func test_givenEmptyPool_whenAccessInitializedInjectedObject_thenReturnsValue() {
        let object = TestObject<String, Pool>(pool: Pool())
        object.object = .string1
        XCTAssertEqual(object.object, .string1)
    }

    func test_givenPoolWithObjectAddedByType_whenAccessInjectedObject_thenReturnsValueByType() {
        let string: String = .string1
        let pool = Pool().appending(string)
        let object = TestObject<String, Pool>(pool: pool)
        XCTAssertEqual(object.object, string)
    }

    func test_givenPoolWithObjectAddedByKeyPath_whenAccessInjectedObject_thenReturnsValueByKeyPath() {
        let string: String = .string1
        let pool = Pool().appending(\TestObject<String, Pool>.object, string)
        let object = TestObject<String, Pool>(pool: pool)
        XCTAssertEqual(object.object, string)
    }

    func test_givenPoolWithTwoObject_whenAccessInjectedObject_thenReturnsValueByKeyPath() {
        let string1: String = .string1
        let string2: String = .string2

        let pool = Pool()
            .appending(string1)
            .appending(\TestObject<String, Pool>.object, string2)

        let object = TestObject<String, Pool>(pool: pool)

        XCTAssertEqual(object.object, string2)
    }
}

private extension InjectedTests {
    final class TestObject<T, P: AbstractPool>: Injectee<P> {
        @Injected var object: T

        convenience init(pool: P, default: T) {
            self.init(pool: pool)
            self.object = `default`
        }
    }
}

private extension InjectedTests {
    final class TestObjectWithDefaultValue<P: AbstractPool>: Injectee<P> {
        @Injected var object: String = .defaultValue
    }
}

private extension String {
    static let string1: String = "String1"
    static let string2: String = "String2"
    static let defaultValue: String = "default value"
}
