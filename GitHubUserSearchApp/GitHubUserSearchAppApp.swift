//
//  GitHubUserSearchAppApp.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 15.11.2024.
//

import SwiftUI
import SwiftData

@main
struct GitHubUserSearchAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SearchHistory.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
            WindowGroup {
                MainView(context: sharedModelContainer.mainContext) // Pass the context to MainView
            }
            .modelContainer(sharedModelContainer)
    }
}
