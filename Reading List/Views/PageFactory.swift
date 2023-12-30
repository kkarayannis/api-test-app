import Foundation

import ImageLoader
import PageLoader

enum PageType: Hashable {
    case readingList
    case bookInfo(id: String)
}

protocol PageFactory {
    func createPage(for type: PageType) -> any Page
}

final class PageFactoryImplementation: PageFactory {
    private let libraryLoader: LibraryLoading
    private let imageLoader: ImageLoader
    
    init(libraryLoader: LibraryLoading, imageLoader: ImageLoader) {
        self.libraryLoader = libraryLoader
        self.imageLoader = imageLoader
    }
    
    func createPage(for type: PageType) -> any Page {
        switch type {
        case .readingList:
            return createReadingListPage()
        case .bookInfo(let id):
            return createReadingListPage() // TODO: fix
        }
    }
    
    private func createReadingListPage() -> ReadingListPage {
        let viewModel = ReadingListViewModel(libraryLoader: libraryLoader, imageLoader: imageLoader)
        return ReadingListPage(viewModel: viewModel)
    }
}
