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
