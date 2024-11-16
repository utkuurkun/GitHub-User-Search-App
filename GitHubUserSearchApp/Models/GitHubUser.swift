//
//  GitHubUser.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 16.11.2024.
//
import Foundation

struct GitHubUser: Identifiable, Decodable {
    let id: Int
    let login: String
    let avatar_url: String
    let html_url: String // Link to the user's GitHub profile
}

struct GitHubSearchResponse: Decodable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [GitHubUser] // Array of GitHubUser objects
}
