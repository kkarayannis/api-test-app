import Combine
import SwiftUI

import ImageLoader

struct ReadingListView: View {
    @State private var items = [ReadingListItemViewModel]()
    private let viewModel: ReadingListViewModel
    
    init(viewModel: ReadingListViewModel) {
        self.viewModel = viewModel
    }
        
    var body: some View {
        List(items) { item in
            ReadingListItemView(viewModel: item)
        }
        .onReceive(viewModel.itemsPublisher) {
            items = $0
        }
        .refreshable {
            viewModel.loadItems()
        }
    }
}

//#Preview {
//    let viewModel = ReadingListViewModel(libraryLoader: LibraryLoader.fake, imageLoader: ImageLoader.fake)
//    viewModel.items = [ReadingListItemViewModel.example]
//    
//    return ReadingListView(viewModel: viewModel)
//}
