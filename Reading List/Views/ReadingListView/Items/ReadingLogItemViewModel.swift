import Foundation

import ImageLoader

final class ReadingListItemViewModel: Identifiable, Equatable {
    let title: String
    let id: String
    let authors: String
    let year: String
    let coverViewModel: CoverViewModel
    
    init(title: String, id: String, authors: String, year: String, coverViewModel: CoverViewModel) {
        self.title = title
        self.id = id
        self.authors = authors
        self.year = year
        self.coverViewModel = coverViewModel
    }
    
    static func == (lhs: ReadingListItemViewModel, rhs: ReadingListItemViewModel) -> Bool {
        lhs.title == rhs.title &&
        lhs.id == rhs.id &&
        lhs.authors == rhs.authors &&
        lhs.year == rhs.year &&
        lhs.coverViewModel.url == rhs.coverViewModel.url
    }
    
    #if DEBUG
    static var example: Self {
        self.init(
            title: "Title",
            id: "id",
            authors: "Authors",
            year: "2004",
            coverViewModel: CoverViewModel.example
        )
    }
    #endif
}
