//
//  Activity.swift
//  Consolidation4
//
//  Created by Zaheer Moola on 2021/07/11.
//

import Foundation

struct ActivityItem: Codable, Identifiable {
    let id = UUID()
    let title: String
    let details: String
    var completedCount: Int
}

class Activities: ObservableObject {
    init() {
        let decoder = JSONDecoder()
        if let items = UserDefaults.standard.data(forKey: "Activities"),
           let decoded = try? decoder.decode([ActivityItem].self, from: items) {
            self.items = decoded
            return
        }
        items = []
    }

    @Published var items = [ActivityItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
}
