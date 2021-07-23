//
//  User+CoreDataProperties.swift
//  DataConsolidation
//
//  Created by Zaheer Moola on 2021/07/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var about: String?
    @NSManaged public var address: String?
    @NSManaged public var emall: String?
    @NSManaged public var friends: NSSet?

    public var wrappedName: String {
        name ?? "N/A"
    }

    public var wrappedAbout: String {
        about ?? "N/A"
    }

    public var wrappedAddress: String {
        address ?? "N/A"
    }

    public var wrappedEmail: String {
        emall ?? "N/A"
    }

    public var friendsArray: [Friend] {
        let set = friends as? Set<Friend> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for friends
extension User {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: Friend)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: Friend)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension User : Identifiable {

}
