import Combine
import Foundation

import Cache
import DataLoader

protocol BookInfoLoading {
    func bookInfoLoadingPublisher(for bookID: String) -> AnyPublisher<BookInfo, Error>
}

private enum BookLoaderError: Error {
    case invalidURL
    case networkError
}

final class BookInfoLoader: BookInfoLoading {
    private let dataLoader: DataLoading
    private let cache: Caching
    
    init(dataLoader: DataLoading, cache: Caching) {
        self.dataLoader = dataLoader
        self.cache = cache
    }
    
    func bookInfoLoadingPublisher(for bookID: String) -> AnyPublisher<BookInfo, Error> {
        guard let url = OpenLibraryAPI.url(for: bookID) else {
            return Fail(error: BookLoaderError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return dataLoader.loadData(for: url)
            .mapError { error in
                // Handle network error more granularly if needed here.
                NSLog(error.localizedDescription)
                return BookLoaderError.networkError
            }
            .cache(PublisherCache(key: bookID.toBase64(), cache: cache))
            .tryMap {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(BookInfo.self, from: $0)
            }
            .eraseToAnyPublisher()
    }
    
#if DEBUG
    private struct BookInfoLoaderFake: BookInfoLoading {
        func bookInfoLoadingPublisher(for bookID: String) -> AnyPublisher<BookInfo, Error> {
            Fail(error: PreviewError.unimplemented)
                .eraseToAnyPublisher()
        }
    }
    static var fake: BookInfoLoading { BookInfoLoaderFake() }
#endif
}

private enum OpenLibraryAPI {
    private static let bookInfoBaseURL = "https://openlibrary.org"
    
    static func url(for bookID: String) -> URL? {
        guard !bookID.isEmpty else {
            return nil
        }
        
        let path = Self.bookInfoBaseURL + "/\(bookID).json"
        return URL(string: path)
    }
}
