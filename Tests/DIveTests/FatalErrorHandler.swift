//  Created by Alex Balobanov

import DIve
import Foundation

struct FatalErrorHandler {
    let fatalErrorOccured: (Error) -> Void
}

extension FatalErrorHandler: FatalErrorHandling {
    func fatalErrorHandler(_ error: Error) -> Never {
        fatalErrorOccured(error)
        while true {
            Thread.sleep(until: Date.distantFuture)
        }
    }
}
