import Combine
import SwiftUI

import PageLoader

final class ReadingListPage: Page {
    private let viewModel: ReadingListViewModel
    
    init(viewModel: ReadingListViewModel) {
        self.viewModel = viewModel
    }
    
    var view: AnyView {
        ReadingListView(viewModel: viewModel)
            .eraseToAnyView()
    }
    
    var title: String {
        viewModel.title
    }
    
    var loadingStatePublisher: AnyPublisher<PageLoaderState, Never> {
        viewModel.pageStatePublisher
    }
    
    var titleDisplayMode: ToolbarTitleDisplayMode {
        .large
    }
    
    func load() {
        viewModel.loadItems()
    }
}
