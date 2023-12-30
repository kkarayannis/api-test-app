import Foundation

enum CoverImageSize: String {
    case s = "S"
    case m = "M"
    case l = "L"
}

enum CoverImageURL {
    static func url(for id: Int?, size: CoverImageSize) -> URL? {
        guard let id else {
            return nil
        }
        
        return URL(string: "https://covers.openlibrary.org/b/id/\(id)-\(size.rawValue).jpg")
    }
}
