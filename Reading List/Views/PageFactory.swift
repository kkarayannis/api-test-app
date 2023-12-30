import Foundation

import ImageLoader
import PageLoader

enum PageType: Hashable {
    case readingList
    case bookInfo(id: String, title: String)
}

protocol PageFactory {
    func createPage(for type: PageType) -> any Page
}

final class PageFactoryImplementation: PageFactory {
    private let libraryLoader: LibraryLoading
    private let imageLoader: ImageLoading
    private let bookInfoLoader: BookInfoLoading
    
    init(libraryLoader: LibraryLoading, imageLoader: ImageLoading, bookInfoLoader: BookInfoLoading) {
        self.libraryLoader = libraryLoader
        self.imageLoader = imageLoader
        self.bookInfoLoader = bookInfoLoader
    }
    
    func createPage(for type: PageType) -> any Page {
        switch type {
        case .readingList:
            return createReadingListPage()
        case .bookInfo(let id, let title):
            return createBookInfoPage(for: id, title: title)
        }
    }
    
    private func createReadingListPage() -> any Page {
        let viewModel = ReadingListViewModel(libraryLoader: libraryLoader, imageLoader: imageLoader)
        return ReadingListPage(viewModel: viewModel)
    }
    
    private func createBookInfoPage(for id: String, title: String) -> any Page {
        let viewModel = BookInfoViewModel(
            id: id,
            bookInfoLoader: bookInfoLoader,
            imageLoader: imageLoader,
            title: title
        )
        return BookInfoPage(viewModel: viewModel)
    }
}
