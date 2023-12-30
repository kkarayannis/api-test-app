import Foundation

import Cache
import DataLoader
import ImageLoader

/// An object that instantiates and holds references to long-living objects.
protocol ServiceProviding {
    func provideDataLoader() -> DataLoading
    func providePageFactory() -> PageFactory
    func provideCache() -> Caching
}

final class ServiceProvider: ServiceProviding {
    private let dataLoader = DataLoader(urlSession: URLSession.shared)
    func provideDataLoader() -> DataLoading {
        dataLoader
    }
    
    private lazy var imageLoader = ImageLoader(dataLoader: dataLoader, cache: cache)
    
    private let user = UserImplementation()
    
    private let cache = Cache(fileManager: FileManager.default)
    func provideCache() -> Caching {
        cache
    }
    
    private lazy var pageFactory = PageFactoryImplementation(
        readingListLoader: ReadingListLoader(dataLoader: dataLoader, user: user, cache: cache),
        imageLoader: imageLoader,
        bookInfoLoader: BookInfoLoader(dataLoader: dataLoader, cache: cache)
    )
    func providePageFactory() -> PageFactory {
        pageFactory
    }
}
