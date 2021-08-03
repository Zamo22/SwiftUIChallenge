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
    let location: CodableMKPointAnnotation

    enum CodingKeys: CodingKey {
        case name, image, location
    }

    enum DecodingError: Error {
        case decodingFailed
        case encodingFailed
    }

    init(name: String, image: UIImage, location: CodableMKPointAnnotation) {
        self.name = name
        self.image = image
        self.location = location
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decode(CodableMKPointAnnotation.self, forKey: .location)

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
        try container.encode(location, forKey: .location)
    }
}
