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
             
                Color(hex: "CBDEFF")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("GitHub User Search")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    searchField
                    
                    if viewModel.isLoading {
                        ProgressView("Searching...")
                            .foregroundColor(.black)
                            .transition(.opacity)
                            .animation(.easeInOut, value: viewModel.isLoading)
                    }
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
    
    private var resultsAndHistoryList: some View {
        List {
            searchResultsSection
            searchHistorySection
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    private var searchResultsSection: some View {
        Section(header: Text("Search Results").font(.headline).foregroundColor(.black)) {
            if viewModel.searchResults.isEmpty {
                Text("Please enter a username to search.")
                    .foregroundColor(.gray)
            } else {
                ForEach(viewModel.searchResults) { user in
                    NavigationLink(
                        destination: UserDetailView(viewModel: UserDetailViewModel(username: user.login))
                    ) {
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
                        .padding(.vertical, 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var searchHistorySection: some View {
        Section(header: Text("Search History").font(.headline).foregroundColor(.black)) {
            if viewModel.searchHistory.isEmpty {
                Text("No search history.")
                    .foregroundColor(.gray)
            } else {
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
        .listStyle(InsetGroupedListStyle())
    }
}
