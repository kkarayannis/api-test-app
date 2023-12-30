import SwiftUI

import PageLoader

@main
struct ReadingListApp: App {
    private let serviceProvider = ServiceProvider()
    
    var body: some Scene {
        WindowGroup {
            NavigationCoordinator(rootPageType: .readingList, pageFactory: serviceProvider.providePageFactory())
        }
    }
}
