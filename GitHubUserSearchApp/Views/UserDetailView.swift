//
//  UserDetailView.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 15.11.2024.
//

import SwiftUI

struct UserDetailView: View {
    let user: GitHubUser

    var body: some View {
        ZStack {
            // Background color matching the theme
            Color(hex: "CBDEFF")
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Avatar
                AsyncImage(url: URL(string: user.avatar_url)) { image in
                    image.resizable()
                         .scaledToFit()
                         .frame(width: 100, height: 100)
                         .clipShape(Circle())
                         .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 100, height: 100)
                }

                // Username
                Text(user.login)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                // GitHub Profile Link
                Link("View on GitHub", destination: URL(string: user.html_url)!)
                    .font(.body)
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
