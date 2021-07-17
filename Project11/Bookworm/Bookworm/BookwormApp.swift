//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Zaheer Moola on 2021/07/16.
//

import SwiftUI

@main
struct BookwormApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
