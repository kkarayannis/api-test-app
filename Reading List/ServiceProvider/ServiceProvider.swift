import Foundation

import DataLoader
import ImageLoader

protocol ServiceProviding {
    func provideDataLoader() -> DataLoading
    func providePageFactory() -> PageFactory
}

final class ServiceProvider: ServiceProviding {
    private let dataLoader = DataLoader(urlSession: URLSession.shared)
    func provideDataLoader() -> DataLoading {
        dataLoader
    }
    
    private lazy var imageLoader = ImageLoader(dataLoader: dataLoader)
    
    private let user = UserImplementation()
    
    private lazy var pageFactory = PageFactoryImplementation(
        libraryLoader: LibraryLoader(dataLoader: dataLoader, user: user),
        imageLoader: imageLoader,
        bookInfoLoader: BookInfoLoader(dataLoader: dataLoader)
    )
    func providePageFactory() -> PageFactory {
        pageFactory
    }
}
