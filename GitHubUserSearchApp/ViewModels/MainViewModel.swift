//
//  MainViewModel.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 16.11.2024.
//

import SwiftUI
import SwiftData

@MainActor
class MainViewModel: ObservableObject {
    @Published var username: String = "" // User input for search
    @Published var searchResults: [GitHubUser] = [] // Results from GitHub API
    @Published var searchHistory: [SearchHistory] = [] // Persisted search history
    @Published var isLoading: Bool = false // Indicates if a search is in progress
    @Published var errorMessage: String? = nil // Error handling

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        loadSearchHistory()
    }

    func searchUsers() async {
        guard !username.isEmpty else { return }
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
        // Avoid duplicates
        guard !searchHistory.contains(where: { $0.username == username }) else { return }

        let newSearch = SearchHistory(username: username)
        searchHistory.append(newSearch)

        // Save to SwiftData
        context.insert(newSearch)
        do {
            try context.save()
        } catch {
            errorMessage = "Failed to save search history: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }
    }

    func loadSearchHistory() {
        do {
            // Fetch all saved search history from SwiftData
            let history = try context.fetch(FetchDescriptor<SearchHistory>())
            searchHistory = history
        } catch {
            errorMessage = "Failed to load search history: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }
    }

    func deleteHistory(item: SearchHistory) {
        // Remove from UI
        searchHistory.removeAll { $0.id == item.id }

        // Delete from SwiftData
        context.delete(item)
        do {
            try context.save()
        } catch {
            errorMessage = "Failed to delete search history: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }
    }
}
