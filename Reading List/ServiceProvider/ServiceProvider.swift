import Foundation

import DataLoader
import ImageLoader

protocol ServiceProviding {
    func provideDataLoader() -> DataLoading
    func provideViewsFactory() -> ViewsFactory
}

final class ServiceProvider: ServiceProviding {
    private let dataLoader = DataLoader(urlSession: URLSession.shared)
    func provideDataLoader() -> DataLoading {
        dataLoader
    }
    
    private lazy var imageLoader = ImageLoader(dataLoader: dataLoader)
    
    private let user = UserImplementation()
    
    private lazy var openLibraryService = OpenLibraryServiceImplementation(dataLoader: dataLoader, user: user)
    func provideOpenLibraryService() -> OpenLibraryService {
        openLibraryService
    }
    
    private lazy var viewsFactory = ViewsFactoryImplementation(
        libraryLoader: openLibraryService.createLibraryLoader(),
        imageLoader: imageLoader
    )
    func provideViewsFactory() -> ViewsFactory {
        viewsFactory
    }
}
