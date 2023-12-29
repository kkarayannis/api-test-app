import Foundation

struct ReadingLogEntry: Codable {
    let work: Work
}

struct Work: Codable {
    let title: String
    let key: String
    let authorNames: [String]
    let firstPublishYear: Int
    let coverId: Int?
}

struct ReadingLog: Codable {
    let readingLogEntries: [ReadingLogEntry]
}

enum CoverImageSize: String {
    case s = "S"
    case m = "M"
    case l = "L"
}

extension ReadingLogEntry {
    
    func coverImageURL(size: CoverImageSize) -> URL? {
        guard let coverID = work.coverId else {
            return nil
        }
        
        return URL(string: "https://covers.openlibrary.org/b/id/\(coverID)-\(size.rawValue).jpg")
    }
}
