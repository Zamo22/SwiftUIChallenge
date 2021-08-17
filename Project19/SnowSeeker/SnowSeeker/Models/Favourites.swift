//
//  Favourites.swift
//  SnowSeeker
//
//  Created by Zaheer Moola on 2021/08/17.
//

import Foundation

class Favorites: ObservableObject {
    // the actual resorts the user has favorited
    private var resorts: Set<String>

    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"

    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let favouritedResorts = try? JSONDecoder().decode(Set<String>.self, from: data) {
                resorts = favouritedResorts
                return
            }
        }

        self.resorts = []
    }

    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        if let data = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
}
