//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Zaheer Moola on 2021/07/18.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
