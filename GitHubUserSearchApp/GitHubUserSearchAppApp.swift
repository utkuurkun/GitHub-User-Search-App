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
            MainView()
        }
    }

    init() {
        configureRealm()
    }

    private func configureRealm() {
        
        let config = Realm.Configuration(
            schemaVersion: 1, 
            deleteRealmIfMigrationNeeded: true // Since the app is for dev purposes
        )
        
        Realm.Configuration.defaultConfiguration = config

        do {
            _ = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
}
