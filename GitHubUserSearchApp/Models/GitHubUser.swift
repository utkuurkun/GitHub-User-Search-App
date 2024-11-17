//
//  GitHubUser.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 16.11.2024.
//
import Foundation

struct GitHubUser: Identifiable, Decodable, Equatable {
    let id: Int
    let login: String
    let avatar_url: String
    let html_url: String
}

struct GitHubSearchResponse: Decodable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [GitHubUser]
}
