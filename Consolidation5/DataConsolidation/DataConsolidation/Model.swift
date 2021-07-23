import Foundation
import CoreData

struct UserModel: Identifiable, Codable {
    let id: String
    let name: String
    let age: Int
    let email: String
    let address: String
    let about: String
    let friends: [FriendModel]
}

struct FriendModel: Identifiable, Codable {
    let id: String
    let name: String
}
