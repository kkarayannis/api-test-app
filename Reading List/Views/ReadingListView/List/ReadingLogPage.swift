import Combine
import Foundation
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
    
    func load() {
        viewModel.loadItems()
    }
    
    
}
