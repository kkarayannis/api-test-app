import Foundation

protocol User {
    var username: String { get }
}

final class UserImplementation: User {
    let username = "viper40113176"
}
