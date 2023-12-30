import Combine
import Foundation

import DataLoader

protocol BookInfoLoading {
    func bookInfoLoadingPublisher(for bookID: String) -> AnyPublisher<Book, Error>
}

private enum BookLoaderError: Error {
    case invalidURL
    case networkError
}

final class BookInfoLoader: BookInfoLoading {
    private let dataLoader: DataLoading
    
    init(dataLoader: DataLoading) {
        self.dataLoader = dataLoader
    }
    
    func bookInfoLoadingPublisher(for bookID: String) -> AnyPublisher<Book, Error> {
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
        // TODO: Caching
            .tryMap {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(Book.self, from: $0)
            }
            .eraseToAnyPublisher()
    }
    
#if DEBUG
    private struct BookInfoLoaderFake: BookInfoLoading {
        func bookInfoLoadingPublisher(for bookID: String) -> AnyPublisher<Book, Error> {
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
