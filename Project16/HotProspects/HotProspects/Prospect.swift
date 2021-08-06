//
//  Prospect.swift
//  HotProspects
//
//  Created by Zaheer Moola on 2021/08/05.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    private(set) var dateAdded = Date()
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    static let saveKey = "SavedData"
    @Published private(set) var people: [Prospect]

    init() {
        let fileName = FileManager.getDocumentsDirectory().appendingPathComponent(Self.saveKey)

        do {
            let data = try Data(contentsOf: fileName)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            people = []
        }
    }

    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }

    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }

    private func save() {
        do {
            let fileName = FileManager.getDocumentsDirectory().appendingPathComponent(Self.saveKey)
            let data = try JSONEncoder().encode(people)
            try data.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }

    func sortByName() {
        people.sort(by: { $0.name < $1.name })
    }

    func sortByDateAdded() {
        people.sort(by: { $0.dateAdded < $1.dateAdded })
    }
}

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        let paths = self.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
