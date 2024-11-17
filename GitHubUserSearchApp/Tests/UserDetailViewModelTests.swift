//
//  UserDetailViewModelTests.swift
//  GitHubUserSearchAppTests
//
//  Created by Utku Urkun on 17.11.2024.
//

import XCTest
@testable import GitHubUserSearchApp

@MainActor
final class UserDetailViewModelTests: XCTestCase {

    var viewModel: UserDetailViewModel!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchUserDetailsWithUsername() async {
        // Given
        viewModel = UserDetailViewModel(username: "utkuurkun")

        // When
        await viewModel.fetchUserDetails()

        // Then
        XCTAssertNotNil(viewModel.userDetails, "User details should not be nil for a valid username.")
        XCTAssertEqual(viewModel.userDetails?.login, "utkuurkun", "The username in user details should match the input.")
    }

    func testFetchUserDetailsNetworkError() async {
        // Simulate network disconnection
        // Temporarily disable internet or intercept the request to simulate failure
        viewModel = UserDetailViewModel(username: "anyusername")

        // When
        
        await viewModel.fetchUserDetails()

        // Then
        XCTAssertNil(viewModel.userDetails, "User details should be nil for a network error.")
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set for a network error.")
    }

    func testLoadingStateDuringFetch() async {
        // Given
        viewModel = UserDetailViewModel(username: "mojombo")

        // When
        XCTAssertTrue(viewModel.isLoading, "isLoading should be true when fetch begins.")
        await viewModel.fetchUserDetails()
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false when fetch completes.")
    }
}
