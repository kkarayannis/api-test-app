import Combine
import Foundation

import Cache
import DataLoader

protocol LibraryLoading {
    var readingLogLoadingPublisher: AnyPublisher<ReadingLog, Error> { get }
}

private enum LibraryLoaderError: Error {
    case invalidURL
    case networkError
}

final class LibraryLoader: LibraryLoading {
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
            return Fail(error: LibraryLoaderError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return dataLoader.loadData(for: url)
            .mapError { error in
                // Handle network error more granularly if needed here.
                NSLog(error.localizedDescription)
                return LibraryLoaderError.networkError
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
    private struct LibraryLoaderFake: LibraryLoading {
        var readingLogLoadingPublisher: AnyPublisher<ReadingLog, Error> {
            Fail(error: PreviewError.unimplemented)
                .eraseToAnyPublisher()
        }
    }
    static var fake: LibraryLoading { LibraryLoaderFake() }
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
