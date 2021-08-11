//
//  Card.swift
//  FlashZilla
//
//  Created by Zaheer Moola on 2021/08/11.
//

import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String

    static var example: Card {
        Card(prompt: "Who played the 12th Doctor in Doctor Who?", answer: "Peter Capaldi")
    }
}
