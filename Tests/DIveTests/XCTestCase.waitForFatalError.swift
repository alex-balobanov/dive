// Created by Alex Balobanov

import XCTest
import os
import DIve

extension XCTestCase {
    func waitForFatalError<P: AbstractPool & Sendable>(
        timeout: TimeInterval = .timeout,
        pool: P,
        block: @escaping @Sendable (P) -> Void
    ) -> Error? {
        let expectation = self.expectation(description: "FatalError")

        let receivedError = OSAllocatedUnfairLock<Error?>(initialState: nil)
        let fatalErrorHandler = FatalErrorHandler(fatalErrorOccured: { error in
            receivedError.withLock { $0 = error }
            expectation.fulfill()
        })

        DispatchQueue.global(qos: .userInitiated).async {
            block(pool.appending(fatalErrorHandler))
        }

        wait(for: [expectation], timeout: timeout)

        return receivedError.withLock { $0 }
    }
}

private extension TimeInterval {
    static let timeout: Self = 1
}
