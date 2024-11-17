//
//  MainViewModelTests.swift
//  GitHubUserSearchAppTests
//
//  Created by Utku Urkun on 17.11.2024.
//

import XCTest
@testable import GitHubUserSearchApp

@MainActor
final class MainViewModelTests: XCTestCase {

    var viewModel: MainViewModel!

    override func setUp() {
        super.setUp()
        viewModel = MainViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testSearchWithValidUsername() async {
        // Given
        viewModel.username = "validUser"

        // When
        await viewModel.searchUsers()

        // Then
        XCTAssertFalse(viewModel.searchResults.isEmpty, "Search results should not be empty for a valid username.")
    }

    func testSearchWithEmptyUsername() async {
        // Given
        viewModel.username = ""

        // When
        await viewModel.searchUsers()

        // Then
        XCTAssertTrue(viewModel.searchResults.isEmpty, "Search results should be empty when username is empty.")
    }

    func testSaveSearch() {
        // Given
        viewModel.username = "exampleSearch"

        // When
        viewModel.saveSearch()

        // Then
        XCTAssertEqual(viewModel.searchHistory.first?.username, "exampleSearch", "The first search history item should match the saved username.")
    }

    func testDeleteHistory() {
        // Given
        viewModel.username = "testDelete"
        viewModel.saveSearch()
        let firstItem = viewModel.searchHistory.first

        // When
        if let item = firstItem {
            viewModel.deleteHistory(item: item)
        }

        // Then
        XCTAssertTrue(viewModel.searchHistory.isEmpty, "Search history should be empty after deleting the only item.")
    }
}
