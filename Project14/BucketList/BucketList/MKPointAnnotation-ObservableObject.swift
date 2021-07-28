//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Zaheer Moola on 2021/07/28.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get { title ?? "Unknown Value" }
        set { title = newValue }
    }

    public var wrappedSubtitle: String {
        get { subtitle ?? "Unknown Value" }
        set { subtitle = newValue }
    }
}
