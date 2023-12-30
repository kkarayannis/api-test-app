import Combine
import Foundation

import Cache
import DataLoader

/// Loads the reading list information from the network
protocol ReadingListLoading {
    var readingLogLoadingPublisher: AnyPublisher<ReadingLog, Error> { get }
}

private enum ReadingListLoaderError: Error {
    case invalidURL
    case networkError
}

final class ReadingListLoader: ReadingListLoading {
    private let dataLoader: DataLoading
    private let user: User
    private let cache: Caching
    
    init(dataLoader: DataLoading, user: User, cache: Caching) {
        self.dataLoader = dataLoader
        self.user = user
        self.cache = cache
    }
    
    var readingLogLoadingPublisher: AnyPublisher<ReadingLog, Error> {
        guard let url = OpenLibraryAPI.url(for: user.username) else {
            return Fail(error: ReadingListLoaderError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return dataLoader.loadData(for: url)
            .mapError { error in
                // Handle network error more granularly if needed here.
                NSLog(error.localizedDescription)
                return ReadingListLoaderError.networkError
            }
            .cache(PublisherCache(key: "library".toBase64(), cache: cache))
            .tryMap {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(ReadingLog.self, from: $0)
            }
            .eraseToAnyPublisher()
    }
    
    #if DEBUG
    private struct ReadingListLoaderFake: ReadingListLoading {
        var readingLogLoadingPublisher: AnyPublisher<ReadingLog, Error> {
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
