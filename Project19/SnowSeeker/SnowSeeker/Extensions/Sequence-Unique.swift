//
//  Sequence-Unique.swift
//  SnowSeeker
//
//  Created by Zaheer Moola on 2021/08/17.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
