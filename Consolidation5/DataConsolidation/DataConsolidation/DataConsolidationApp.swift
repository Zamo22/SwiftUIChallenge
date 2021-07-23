//
//  DataConsolidationApp.swift
//  DataConsolidation
//
//  Created by Zaheer Moola on 2021/07/23.
//

import SwiftUI

@main
struct DataConsolidationApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
