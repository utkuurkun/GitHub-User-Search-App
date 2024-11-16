//
//  MainView.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 15.11.2024.
//

import SwiftUI
import RealmSwift

struct MainView: View {
    @StateObject private var viewModel: MainViewModel

    init() {
        _viewModel = StateObject(wrappedValue: MainViewModel())
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color(hex: "CBDEFF")
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Title
                    Text("GitHub User Search")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    // Search Field
                    searchField

                    // Loading Indicator
                    if viewModel.isLoading {
                        ProgressView("Searching...")
                            .foregroundColor(.black)
                            .transition(.opacity) // Add fade-in/fade-out animation
                            .animation(.easeInOut, value: viewModel.isLoading)
                    }

                    // Results and History List
                    resultsAndHistoryList
                }
                .padding()
            }
            .navigationTitle("")
            .alert("Something Went Wrong", isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.body)
                        .foregroundColor(.red)
                }
            }
        }
    }

    // MARK: - Search Field
    private var searchField: some View {
        HStack {
            TextField("Enter GitHub username", text: $viewModel.username)
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .foregroundColor(.black)
                .padding(.horizontal)

            Button(action: {
                Task {
                    await viewModel.searchUsers()
                }
            }) {
                Text("Search")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
    }

    // MARK: - Results and History List
    private var resultsAndHistoryList: some View {
        List {
            // Search Results Section
            if viewModel.searchResults.isEmpty {
                Section(header: Text("Search Results").font(.headline).foregroundColor(.black)) {
                    Text("Please enter a username to search.")
                        .foregroundColor(.gray)
                }
            } else {
                Section(header: Text("Search Results").font(.headline).foregroundColor(.black)) {
                    ForEach(viewModel.searchResults) { user in
                        NavigationLink(destination: UserDetailView(user: user)) {
                            HStack {
                                AsyncImage(url: URL(string: user.avatar_url)) { image in
                                    image.resizable()
                                         .scaledToFit()
                                         .frame(width: 50, height: 50)
                                         .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                }
                                Text(user.login)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }

            // Search History Section
            if viewModel.searchHistory.isEmpty {
                Section(header: Text("Search History").font(.headline).foregroundColor(.black)) {
                    Text("No search history.")
                        .foregroundColor(.gray)
                }
            } else {
                Section(header: Text("Search History").font(.headline).foregroundColor(.black)) {
                    ForEach(viewModel.searchHistory) { historyItem in
                        Button(action: {
                            viewModel.username = historyItem.username
                            Task {
                                await viewModel.searchUsers()
                            }
                        }) {
                            Text(historyItem.username)
                                .foregroundColor(.blue)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deleteHistory(item: historyItem)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
