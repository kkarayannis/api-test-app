import Combine
import Foundation

extension Publisher<Data, Error> {
    public func cacheable(cache: PublisherCaching) -> AnyPublisher<Data, Error> {
        cache.cacheElements(from: self)
        
        let cachePublisher = cache.cachedDataPublisher
            .ignoreError() // We don't care about errors due to a cache misses.
            .prefix(untilOutputFrom: self)
        
        var hasEmittedElement = false
        return cachePublisher
            .merge(with: self)
            .handleEvents(receiveOutput: { _ in
                hasEmittedElement = true
            })
            .tryCatch { error in
                if !hasEmittedElement {
                    throw error
                }
                return Empty<Data, Error>()
            }
            .eraseToAnyPublisher()
    }
}

private extension Publisher {
    func ignoreError() -> AnyPublisher<Output, Failure> {
        map { Optional($0) }
        .replaceError(with: nil)
        .compactMap { $0 }
        .setFailureType(to: Failure.self)
        .eraseToAnyPublisher()
    }
}
