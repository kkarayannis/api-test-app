@testable import Reading_List

import Combine
import XCTest

final class ReadingListLoaderFake: ReadingListLoading {
    
    var readingLog: ReadingLog?
    var error: Error?
    var loadingPublisher: AnyPublisher<ReadingLog, Error> {
        guard readingLog != nil || error != nil else {
            XCTFail("Both readingLog and error are nil")
            return Empty<ReadingLog, Error>()
                .eraseToAnyPublisher()
        }
        
        if let error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else if let readingLog {
            return Just(readingLog)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Empty<ReadingLog, Error>()
            .eraseToAnyPublisher()
    }
}
