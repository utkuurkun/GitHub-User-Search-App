//
//  GitHubUserSearchAppApp.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 15.11.2024.
//

import SwiftUI
import RealmSwift

@main
struct GitHubUserSearchAppApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            MainView() // No context is needed anymore
        }
    }

    init() {
        configureRealm()
    }

    private func configureRealm() {
        // Optional: Specify a custom configuration
        let config = Realm.Configuration(
            schemaVersion: 1, 
            deleteRealmIfMigrationNeeded: true // Since the app is for dev purposes
        )
        
        Realm.Configuration.defaultConfiguration = config

        // Verify Realm Initialization
        do {
            _ = try Realm() // Initializes Realm to ensure it's correctly configured
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
}
