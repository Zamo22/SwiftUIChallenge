//
//  FinalChallengeApp.swift
//  FinalChallenge
//
//  Created by Zaheer Moola on 2021/08/15.
//

import SwiftUI

@main
struct FinalChallengeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
