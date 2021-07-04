//
//  Expense.swift
//  iExpense
//
//  Created by Zaheer Moola on 2021/07/04.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    init() {
        let decoder = JSONDecoder()
        if let items = UserDefaults.standard.data(forKey: "Items"),
           let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
            self.items = decoded
            return
        }
        items = []
    }

    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
}
