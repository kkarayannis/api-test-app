import Combine
import Foundation
import XCTest

import DataLoader

final class DataLoaderFake: DataLoading {
    
    var data: Data?
    var error: URLError?
    func loadData(
        for url: URL,
        parameters: [String : Any]?,
        method: DataLoaderMethod
    ) -> AnyPublisher<Data, URLError> {
        guard data != nil || error != nil else {
            XCTFail("Both data and error are nil")
            return Empty<Data, URLError>()
                .eraseToAnyPublisher()
        }
        
        if let error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else if let data {
            return Just(data)
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
        
        return Empty<Data, URLError>()
            .eraseToAnyPublisher()
    }
}
