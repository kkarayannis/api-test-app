import Foundation

import DataLoader

protocol OpenLibraryService {
    func createLibraryLoader() -> LibraryLoading
}

final class OpenLibraryServiceImplementation: OpenLibraryService {
    private let dataLoader: DataLoading
    private let user: User
    
    init(dataLoader: DataLoading, user: User) {
        self.dataLoader = dataLoader
        self.user = user
    }
    
    func createLibraryLoader() -> LibraryLoading {
        LibraryLoader(dataLoader: dataLoader, user: user)
    }
}
