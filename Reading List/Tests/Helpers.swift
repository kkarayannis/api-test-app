@testable import Reading_List

import Foundation

enum TestError: Error {
    case generic
    case dataError
}

final class Helpers {
    static func responseData() throws -> Data {
        let bundle = Bundle(for: Self.self)
        guard let url = bundle.url(forResource: "want-to-read", withExtension: "json") else {
            throw TestError.dataError
        }
        return try Data(contentsOf: url)
    }
    
    static func responseReadingLog() throws -> ReadingLog {
        let data = try responseData()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(ReadingLog.self, from: data)
    }
}
