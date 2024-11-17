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
    @Published var username: String = ""
    @Published var searchResults: [GitHubUser] = []
    @Published var searchHistory: [SearchHistory] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedUserDetails: GitHubUserDetails? = nil

    private var realm: Realm {
        try! Realm()
    }

    init() {
        loadSearchHistory()
    }

    func searchUsers() async {
        guard !username.isEmpty else {
            searchResults = []
            errorMessage = nil
            return }
        isLoading = true
        errorMessage = nil

        do {
            let results = try await GitHubService.shared.searchUsers(username: username)
            self.searchResults = results
            saveSearch()
        } catch {
            errorMessage = "Failed to fetch users: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }

        isLoading = false
    }

    func saveSearch() {
        let newSearch = SearchHistory(username: username)

        do {
            try realm.write {
                realm.add(newSearch)
            }
            loadSearchHistory()
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
            loadSearchHistory()
        } catch {
            errorMessage = "Failed to delete search history: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }
    }
}
