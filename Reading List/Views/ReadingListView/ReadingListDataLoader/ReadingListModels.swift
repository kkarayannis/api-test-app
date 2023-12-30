import Foundation

/// The objects that are received from the reading list endpoint.

struct ReadingListEntry: Codable {
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
    let readingLogEntries: [ReadingListEntry]
}
