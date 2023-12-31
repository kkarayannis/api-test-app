import Combine
import SwiftUI

import PageLoader

final class BookInfoPage: Page {
    private let viewModel: BookInfoViewModel
    
    init(viewModel: BookInfoViewModel) {
        self.viewModel = viewModel
    }
    
    var view: AnyView {
        BookInfoView(viewModel: viewModel)
            .eraseToAnyView()
    }
    
    var title: String {
        viewModel.title
    }
    
    var loadingStatePublisher: AnyPublisher<PageLoaderState, Never> {
        viewModel.pageStatePublisher
    }
    
    var titleDisplayMode: ToolbarTitleDisplayMode {
        .inline
    }
    
    func load() {
        viewModel.loadBookInfo()
    }
    
}
