// Created by Alex Balobanov

/// The protocol describes a handler that can handle fatal errors, usually
/// the last handler that will be called before the termination of the process.
public protocol FatalErrorHandling {
    /// The function handles a fatal error and implements the code for the process termination.
    /// - Parameter error: a fatal error.
    /// - Returns: Never.
    func fatalErrorHandler(_ error: Error) -> Never
}
