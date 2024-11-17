//
//  GitHubService.swift
//  GitHub User Search App
//
//  Created by Utku Urkun on 16.11.2024.
//

import Foundation

class GitHubService: GitHubServiceProtocol {
    static let shared = GitHubService()
    private init() {}

    func searchUsers(username: String) async throws -> [GitHubUser] {
        guard let url = URL(string: "https://api.github.com/search/users?q=\(username)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(GitHubSearchResponse.self, from: data)
        return decodedResponse.items
    }
    
    func getUserDetails(username: String) async throws -> GitHubUserDetails {
            guard let url = URL(string: "https://api.github.com/users/\(username)") else {
                throw URLError(.badURL)
            }

            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            let decodedDetails = try JSONDecoder().decode(GitHubUserDetails.self, from: data)
            return decodedDetails
        }
}

protocol GitHubServiceProtocol {
    func searchUsers(username: String) async throws -> [GitHubUser]
    func getUserDetails(username: String) async throws -> GitHubUserDetails
}
