import Combine
import Foundation

import PageLoader
import ImageLoader

final class ReadingListViewModel {
    private let readingListLoader: ReadingListLoading
    private let imageLoader: ImageLoading
        
    let title = "Reading List" // TODO: Localize
    
    @Published private var itemsResult: Result<[ReadingListItemViewModel], Error>?
    private var cancellable: AnyCancellable?
    
    init(readingListLoader: ReadingListLoading, imageLoader: ImageLoading) {
        self.readingListLoader = readingListLoader
        self.imageLoader = imageLoader
    }
    
    lazy var itemsPublisher: AnyPublisher<[ReadingListItemViewModel], Never> = $itemsResult
        .removeDuplicates {
            if case .success(let lhs) = $0, case .success(let rhs) = $1 {
                return lhs == rhs
            }
            return false
        }
        .compactMap { result in
            switch result {
            case .success(let items):
                return items
            case .failure, .none:
                return nil
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    lazy var pageStatePublisher: AnyPublisher<PageLoaderState, Never> = $itemsResult
        .tryCompactMap { result in
            switch result {
            case .success(let items):
                return items
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
    
    func loadItems() {
        cancellable = readingListLoader.loadingPublisher
            .receive(on: DispatchQueue.main)
            .map { [weak self] readingLog in
                guard let self else {
                    return []
                }
                return self.items(from: readingLog)
            }
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let failure) = completion {
                    NSLog(failure.localizedDescription)
                    self?.itemsResult = .failure(failure)
                }
            }, receiveValue: { [weak self] items in
                self?.itemsResult = .success(items)
            })
    }
    
    private func items(from readingLog: ReadingLog) -> [ReadingListItemViewModel] {
        readingLog.readingLogEntries.map {
            ReadingListItemViewModel(
                title: $0.work.title,
                id: $0.work.key,
                authors: $0.work.authorNames.localizedJoined(),
                year: String($0.work.firstPublishYear),
                coverViewModel: CoverViewModel(
                    url: CoverImageURL.url(for: $0.work.coverId, size: .m),
                    imageLoader: imageLoader
                )
            )
        }
    }
    
    #if DEBUG
    // Used for Previews only
    func __setItems(_ items: [ReadingListItemViewModel]) {
        itemsResult = .success(items)
    }
    #endif
}
