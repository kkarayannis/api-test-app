import SwiftUI

struct ReadingListItemView: View {
    private let viewModel: ReadingListItemViewModel
    
    init(viewModel: ReadingListItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .top) {
            CoverView(model: viewModel.coverModel)
                .frame(height: 150)
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(.headline)
                Text(viewModel.authors)
                    .font(.subheadline)
                Text(viewModel.year)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

#Preview {
    return ReadingListItemView(viewModel: ReadingListItemViewModel.example)
}
