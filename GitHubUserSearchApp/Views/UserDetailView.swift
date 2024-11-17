//
//  UserDetailView.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 15.11.2024.
//

import SwiftUI

struct UserDetailView: View {
    @StateObject var viewModel: UserDetailViewModel

    var body: some View {
        ZStack {
            Color(hex: "CBDEFF")
                .ignoresSafeArea(edges: .all)

            if viewModel.isLoading {
                ProgressView("Loading details...")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text(errorMessage)
                        .font(.body)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()

                    Button(action: {
                        if !viewModel.isLoading {
                            viewModel.fetchUserDetails()
                        }
                    }) {
                        Text(viewModel.isLoading ? "Loading..." : "Retry")
                            .padding()
                            .background(viewModel.isLoading ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(viewModel.isLoading)
                }
            } else if let userDetails = viewModel.userDetails {
                // User Details State
                ScrollView {
                    VStack(spacing: 16) {
                        // User Avatar
                        AsyncImage(url: URL(string: userDetails.avatar_url)) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }

                        Text(userDetails.name ?? "No Name")
                            .font(.title)
                            .padding(.bottom, 5)
                        Text(userDetails.bio ?? "No Bio")
                            .italic()
                            .foregroundColor(.gray)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Repositories: \(userDetails.public_repos)")
                            Text("Followers: \(userDetails.followers)")
                            Text("Following: \(userDetails.following)")
                        }

                        if let profileURL = URL(string: userDetails.html_url), UIApplication.shared.canOpenURL(profileURL) {
                            Link("Visit Profile", destination: profileURL)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        } else {
                            Text("Profile link not available")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(hex: "CBDEFF"))
                }
            } else {
                Text("No details available.")
                    .font(.body)
                    .foregroundColor(.gray)
            }
        }
    }
}
