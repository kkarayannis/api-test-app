import Combine
import SwiftUI

import ImageLoader

/// View that displays a list of books.
struct ReadingListView: View {
    @State private var items = [ReadingListItemViewModel]()
    private let viewModel: ReadingListViewModel
    
    init(viewModel: ReadingListViewModel) {
        self.viewModel = viewModel
    }
        
    var body: some View {
        List(items) { item in
            NavigationLink(value: PageType.bookInfo(id: item.id, title: item.title)) {
                ReadingListItemView(viewModel: item)
            }
        }
        .onReceive(viewModel.itemsPublisher) {
            items = $0
        }
    }
}

#Preview {
    let viewModel = ReadingListViewModel(readingListLoader: ReadingListLoader.fake, imageLoader: ImageLoader.fake)
    viewModel.__setItems([ReadingListItemViewModel.example])
    
    return ReadingListView(viewModel: viewModel)
}
