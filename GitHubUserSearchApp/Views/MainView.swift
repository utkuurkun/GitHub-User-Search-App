//
//  MainView.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 15.11.2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var viewModel: MainViewModel

    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: MainViewModel(context: context))
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
                    }

                    // Results and History List
                    resultsAndHistoryList
                }
                .padding()
            }
            .navigationTitle("")
            .alert("Error", isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
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
                                Circle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(width: 50, height: 50)
                            }
                            Text(user.login) // Updated to `login` for API compliance
                                .foregroundColor(.black)
                        }
                    }
                }
            }

            // Search History Section
            Section(header: Text("Search History").font(.headline).foregroundColor(.black)) {
                ForEach(viewModel.searchHistory) { historyItem in
                    Button(action: {
                        viewModel.username = historyItem.username // Set the username
                        Task {
                            await viewModel.searchUsers() // Trigger search
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
        .listStyle(InsetGroupedListStyle())
    }
}

#Preview {
    let container = try! ModelContainer(for: SearchHistory.self) // Create container
    let context = container.mainContext // Get the context

    // Add mock data to the context for preview purposes
    let mockSearch1 = SearchHistory(username: "mockuser1")
    let mockSearch2 = SearchHistory(username: "mockuser2")
    context.insert(mockSearch1)
    context.insert(mockSearch2)

    return MainView(context: context)
}
