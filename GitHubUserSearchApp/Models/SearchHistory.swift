//
//  SearchHistory.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 16.11.2024.
//

import RealmSwift
import Foundation

class SearchHistory: Object, Identifiable {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var username: String
    @Persisted var timestamp: Date = Date() // Automatically set the current date and time

    convenience init(username: String) {
        self.init()
        self.username = username
    }
}
