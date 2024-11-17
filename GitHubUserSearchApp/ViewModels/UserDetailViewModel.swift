//
//  UserDetailViewModel.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 17.11.2024.
//

import SwiftUI

@MainActor
class UserDetailViewModel: ObservableObject {
    @Published var userDetails: GitHubUserDetails? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let username: String

    init(username: String) {
        self.username = username
        fetchUserDetails()
    }

    func fetchUserDetails() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let details = try await GitHubService.shared.getUserDetails(username: username)
                self.userDetails = details
            } catch {
                errorMessage = "Failed to load details: \(error.localizedDescription)"
                print(errorMessage ?? "Unknown error")
            }
            isLoading = false
        }
    }
}
