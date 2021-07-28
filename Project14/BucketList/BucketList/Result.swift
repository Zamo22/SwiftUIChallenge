//
//  Result.swift
//  BucketList
//
//  Created by Zaheer Moola on 2021/07/28.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [String: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: Terms?

    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }

    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.title == rhs.title
    }

    var description: String {
        terms?.termsDescription.first ?? "No further information"
    }
}

struct Terms: Codable {
    let termsDescription: [String]

    enum CodingKeys: String, CodingKey {
        case termsDescription = "description"
    }
}
