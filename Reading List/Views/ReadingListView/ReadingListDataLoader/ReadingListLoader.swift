import Combine
import Foundation

import Cache
import DataLoader

/// Loads the reading list information from the network
protocol ReadingListLoading {
    var loadingPublisher: AnyPublisher<ReadingLog, Error> { get }
}

enum ReadingListLoaderError: Error {
    case invalidURL
    case networkError
}

final class ReadingListLoader: ReadingListLoading {
    private static let readingListCacheKey = "readingList"
    private let dataLoader: DataLoading
    private let user: User
    private let cache: Caching
    
    init(dataLoader: DataLoading, user: User, cache: Caching) {
        self.dataLoader = dataLoader
        self.user = user
        self.cache = cache
    }
    
    var loadingPublisher: AnyPublisher<ReadingLog, Error> {
        guard let url = OpenLibraryAPI.url(for: user.username) else {
            return Fail(error: ReadingListLoaderError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return dataLoader.dataLoadingPublisher(for: url)
            .mapError { error in
                // Handle network error more granularly if needed here.
                NSLog(error.localizedDescription)
                return ReadingListLoaderError.networkError
            }
            .cache(PublisherCache(key: Self.readingListCacheKey.toBase64(), cache: cache))
            .tryMap {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(ReadingLog.self, from: $0)
            }
            .eraseToAnyPublisher()
    }
    
    #if DEBUG
    private struct ReadingListLoaderFake: ReadingListLoading {
        var loadingPublisher: AnyPublisher<ReadingLog, Error> {
            Fail(error: PreviewError.unimplemented)
                .eraseToAnyPublisher()
        }
    }
    static var fake: ReadingListLoading { ReadingListLoaderFake() }
    #endif
}

private enum OpenLibraryAPI {
    private static let userReadingListBaseURL = "https://openlibrary.org/people"
    private static let userReadingListEndpoint = "/books/want-to-read.json"
    
    static func url(for user: String) -> URL? {
        guard !user.isEmpty else {
            return nil
        }
        
        let path = Self.userReadingListBaseURL + "/\(user)" + Self.userReadingListEndpoint
        return URL(string: path)
    }
}
