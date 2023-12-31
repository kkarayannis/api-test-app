import Combine
import Foundation

import ImageLoader
import PageLoader

final class BookInfoViewModel {
    private let id: String
    private let bookInfoLoader: BookInfoLoading
    let imageLoader: ImageLoading
    
    var title: String
    
    @Published private var bookInfoResult: Result<BookInfo, Error>?
    private var cancellable: AnyCancellable?
    
    lazy var bookInfoPublisher: AnyPublisher<BookInfo, Never> = $bookInfoResult
        .compactMap { result in
            switch result {
            case .success(let bookInfo):
                return bookInfo
            case .failure, .none:
                return nil
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    lazy var pageStatePublisher: AnyPublisher<PageLoaderState, Never> = $bookInfoResult
        .tryCompactMap { result in
            switch result {
            case .success(let bookInfo):
                return bookInfo
            case .failure(let error):
                throw error
            case .none:
                return nil
            }
        }
        .map { _ in .loaded } // If we receive any element, we consider the page loaded.
        .removeDuplicates()
        .replaceError(with: .error)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    init(id: String, bookInfoLoader: BookInfoLoading, imageLoader: ImageLoading, title: String) {
        self.id = id
        self.bookInfoLoader = bookInfoLoader
        self.imageLoader = imageLoader
        self.title = title
    }
    
    func loadBookInfo() {
        cancellable = bookInfoLoader.loadingPublisher(for: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let failure) = completion {
                    NSLog(failure.localizedDescription)
                    self?.bookInfoResult = .failure(failure)
                }
            }, receiveValue: { [weak self] bookInfo in
                self?.bookInfoResult = .success(bookInfo)
            })
    }
    
#if DEBUG
    // Used for Previews only
    func __setBookInfo(_ bookInfo: BookInfo) {
        bookInfoResult = .success(bookInfo)
    }
#endif
}
