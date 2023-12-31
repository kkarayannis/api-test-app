import SwiftUI

extension Array where Element == String {
    /// Joins an array of strings but reverses the array in RTL languages.
    func localizedJoined(separator: String = ", ") -> String {
        let isRTL = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
        let localizedArray = isRTL ? reversed() : self
        return localizedArray.joined(separator: separator)
    }
}
