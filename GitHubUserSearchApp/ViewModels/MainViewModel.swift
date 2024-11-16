//
//  MainViewModel.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 16.11.2024.
//

import SwiftUI
import RealmSwift

@MainActor
class MainViewModel: ObservableObject {
    @Published var username: String = "" // User input for search
    @Published var searchResults: [GitHubUser] = [] // Results from GitHub API
    @Published var searchHistory: [SearchHistory] = [] // Persisted search history
    @Published var isLoading: Bool = false // Indicates if a search is in progress
    @Published var errorMessage: String? = nil // Error handling

    private var realm: Realm {
        // Access the globally initialized Realm instance
        try! Realm()
    }

    init() {
        loadSearchHistory()
    }

    func searchUsers() async {
        guard !username.isEmpty else {
            searchResults = [] // Clear the results
            errorMessage = nil // Reset any previous error
            return }
        isLoading = true
        errorMessage = nil

        do {
            // Fetch users from GitHub API
            let results = try await GitHubService.shared.searchUsers(username: username)
            self.searchResults = results

            // Save the search
            saveSearch()
        } catch {
            errorMessage = "Failed to fetch users: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }

        isLoading = false
    }

    func saveSearch() {
        // Create a new search history entry
        let newSearch = SearchHistory(username: username)

        do {
            try realm.write {
                realm.add(newSearch) // Allow duplicates
            }
            loadSearchHistory() // Reload history to update the UI
        } catch {
            errorMessage = "Failed to save search history: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }
    }

    func loadSearchHistory() {
        let history = realm.objects(SearchHistory.self).sorted(byKeyPath: "timestamp", ascending: false)
        self.searchHistory = Array(history)
    }
    
    func deleteHistory(item: SearchHistory) {
        do {
            try realm.write {
                if let objectToDelete = realm.object(ofType: SearchHistory.self, forPrimaryKey: item.id) {
                    realm.delete(objectToDelete)
                }
            }
            loadSearchHistory() // Reload history to update the UI
        } catch {
            errorMessage = "Failed to delete search history: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }
    }
}
