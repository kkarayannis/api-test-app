import SwiftUI

import PageLoader

@main
struct ReadingListApp: App {
    private let serviceProvider = ServiceProvider()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                let page = serviceProvider.provideViewsFactory().createReadingListPage()
                PageLoader(loadablePage: page)
            }
        }
    }
}
