import Foundation

import ImageLoader

protocol ViewsFactory {
    func createReadingListPage() -> ReadingListPage
}

final class ViewsFactoryImplementation: ViewsFactory {
    private let libraryLoader: LibraryLoading
    private let imageLoader: ImageLoader
    
    init(libraryLoader: LibraryLoading, imageLoader: ImageLoader) {
        self.libraryLoader = libraryLoader
        self.imageLoader = imageLoader
    }
    
    func createReadingListPage() -> ReadingListPage {
        let viewModel = ReadingListViewModel(libraryLoader: libraryLoader, imageLoader: imageLoader)
        return ReadingListPage(viewModel: viewModel)
    }
}
