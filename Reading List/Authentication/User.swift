import Foundation

/// Information about the current user.
protocol User {
    var username: String { get }
}

final class UserImplementation: User {
    let username = "viper40113176"
}
