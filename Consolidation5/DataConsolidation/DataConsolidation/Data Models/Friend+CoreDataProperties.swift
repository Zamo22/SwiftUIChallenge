//
//  Friend+CoreDataProperties.swift
//  DataConsolidation
//
//  Created by Zaheer Moola on 2021/07/23.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String?
    @NSManaged public var origin: User?

    public var wrappedName: String {
        name ?? "N/A"
    }

}

extension Friend : Identifiable {

}
