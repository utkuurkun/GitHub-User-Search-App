//
//  GitHubUserDetails.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 17.11.2024.
//

struct GitHubUserDetails: Codable {
    let login: String
    let id: Int
    let avatar_url: String
    let html_url: String
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let bio: String?
    let public_repos: Int
    let followers: Int
    let following: Int
}
