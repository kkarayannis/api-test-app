import Foundation

import ImageLoader

final class ReadingListItemViewModel: Identifiable {
    let title: String
    let id: String
    let authors: String
    let year: String
    let coverModel: CoverModel
    
    init(title: String, id: String, authors: String, year: String, coverModel: CoverModel) {
        self.title = title
        self.id = id
        self.authors = authors
        self.year = year
        self.coverModel = coverModel
    }
    
    #if DEBUG
    static var example: Self {
        self.init(
            title: "Title",
            id: "id",
            authors: "Authors",
            year: "2004",
            coverModel: CoverModel.example
        )
    }
    #endif
}
