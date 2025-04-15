// Created by Alex Balobanov

import XCTest
import DIve

extension XCTestCase {
    func waitForFatalError<P: AbstractPool>(
        timeout: TimeInterval = .timeout,
        pool: P,
        block: @escaping (P) -> Void
    ) -> Error? {
        let expectation = self.expectation(description: "FatalError")

        var receivedError: Error?
        let fatalErrorHandler = FatalErrorHandler(fatalErrorOccured: { error in
            receivedError = error
            expectation.fulfill()
        })

        DispatchQueue.global(qos: .userInitiated).async {
            block(pool.appending(fatalErrorHandler))
        }

        wait(for: [expectation], timeout: timeout)

        return receivedError
    }
}

private extension TimeInterval {
    static let timeout: Self = 1
}
