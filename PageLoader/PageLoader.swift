import Combine
import SwiftUI

public enum PageLoaderState {
    case loading
    case loaded
    case error
}

public protocol Page {
    var view: AnyView { get }
    var title: String { get }
    var loadingStatePublisher: AnyPublisher<PageLoaderState, Never> { get }
    func load()
}

public struct PageLoader: View {
    let page: any Page
    @State private var state: PageLoaderState = .loading
    
    public init(page: any Page) {
        self.page = page
        
        page.load()
    }
    
    public var body: some View {
        Group {
            switch state {
            case .loading:
                ProgressView()
            case .loaded:
                page.view
            case .error:
                ErrorView() {
                    state = .loading
                    page.load()
                }
            }
        }
        .navigationTitle(page.title)
        .onReceive(page.loadingStatePublisher) {
            state = $0
        }
    }
}
