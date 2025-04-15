// Created by Alex Balobanov

import XCTest
import DIve

final class PoolTests: XCTestCase {
    func test_givenEmptyPool_whenUseTypeSubscript_thenFatalError() {
        let type = TestObject<Pool>.self
        let expectedError = PoolError.objectNotFoundForType(type)

        let emptyPool = Pool()
        let error = waitForFatalError(pool: emptyPool) { pool in
            _ = pool[type]
        }
        XCTAssertEqual(error as? NSError, expectedError as NSError)
    }

    func test_givenEmptyPool_whenUseKeyPathSubscript_thenFatalError() {
        let keyPath = \TestObject<Pool>.object
        let expectedError = PoolError.objectNotFoundForKeyPath(keyPath)

        let emptyPool = Pool()
        let error = waitForFatalError(pool: emptyPool) { pool in
            _ = pool[keyPath]
        }
        XCTAssertEqual(error as? NSError, expectedError as NSError)
    }

    func test_givenEmptyPool_whenUseFind_thenThrowError() {
        let type = TestObject<Pool>.self
        let keyPath = \TestObject<Pool>.object
        let emptyPool = Pool()

        XCTAssertThrowsError(try emptyPool.find(type)) { error in
            XCTAssertEqual(error as NSError, PoolError.objectNotFoundForType(type) as NSError)
        }

        XCTAssertThrowsError(try emptyPool.find(keyPath)) { error in
            XCTAssertEqual(error as NSError, PoolError.objectNotFoundForKeyPath(keyPath) as NSError)
        }
    }

    func test_givenNonEmptyPool_whenUseFindOrSubscript_thenReturnsValue() throws {
        let string1: String = "string1"
        let string2: String = "string2"
        let type1 = type(of: string1)
        let type2 = TestString.self

        let keyPath = \TestObject<Pool>.object

        let pool = Pool()
            .appending(string1)
            .appending(keyPath, string2)

        XCTAssertEqual(try pool.find(type1), string1)
        XCTAssertEqual(try pool.find(type2).asString, string1)
        XCTAssertEqual(try pool.find(keyPath), string2)

        XCTAssertEqual(pool[type1], string1)
        XCTAssertEqual(pool[type2].asString, string1)
        XCTAssertEqual(pool[keyPath], string2)
    }

    func test_givenTwoPools_whenAppending_thenReturnsValidPool() throws {
        let pool1 = Pool()
            .appending(\TestObject<Pool>.object, "1")
            .appending("2")

        let pool2 = Pool()
            .appending(\TestObject<Pool>.object, "3")
            .appending(4)

        let pool3 = pool1.appending(pool2)
        XCTAssertEqual(pool3[\TestObject<Pool>.object], "3")
        XCTAssertEqual(pool3[String.self], "2")
        XCTAssertEqual(pool3[Int.self], 4)
    }
}

private extension PoolTests {
    class TestObject<T: AbstractPool>: Injectee<T> {
        @Injected var object: String
    }
}

private protocol TestString {
    var asString: String { get }
}

extension String: TestString {
    var asString: String { self }
}
