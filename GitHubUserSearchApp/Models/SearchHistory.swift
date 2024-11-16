//
//  SearchHistory.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 16.11.2024.
//

import SwiftData

@Model
final class SearchHistory {
    @Attribute(.unique) var username: String // Username is unique to avoid duplicates

    init(username: String) {
        self.username = username
    }
}
