// Created by Alex Balobanov

extension AbstractPool {
    /// The default fatal error handler.
    /// Calls ``FatalErrorHandling/fatalErrorHandler(_:)`` from the pool or calls the system ``Swift/fatalError(_:)`` function.
    /// - Parameter error: a fatal error.
    /// - Returns: Never.
    func fatalErrorHandler(_ error: Error) -> Never {
        guard let handler = try? find(FatalErrorHandling.self) else {
            fatalError(String(describing: error))
        }
        return handler.fatalErrorHandler(error)
    }
}
