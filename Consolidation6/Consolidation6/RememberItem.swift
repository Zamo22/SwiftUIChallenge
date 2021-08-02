//
//  RememberItem.swift
//  Consolidation6
//
//  Created by Zaheer Moola on 2021/08/02.
//

import SwiftUI

struct RememberItem: Codable, Hashable {
    let name: String
    let image: UIImage

    enum CodingKeys: CodingKey {
        case name, image
    }

    enum DecodingError: Error {
        case decodingFailed
        case encodingFailed
    }

    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let data = try container.decode(Data.self, forKey: .image)
        guard let image = UIImage(data: data) else {
            throw DecodingError.decodingFailed
        }

        self.image = image

    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let data = image.pngData() else {
            throw DecodingError.encodingFailed
        }

        try container.encode(data, forKey: .image)
        try container.encode(name, forKey: .name)
    }
}
