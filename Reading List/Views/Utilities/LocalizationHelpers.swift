import SwiftUI

extension Array where Element == String {
    func localizedJoined(separator: String = ", ") -> String {
        let isRTL = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
        let localizedArray = isRTL ? reversed() : self
        return localizedArray.joined(separator: separator)
    }
}
