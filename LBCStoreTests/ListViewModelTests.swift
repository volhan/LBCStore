//
//  ListViewModelTests.swift
//  LBCStoreTests
//
//  Created by Volhan Salai on 18/04/2024.
//

import XCTest
import Combine

@testable import LBCStore

final class ListViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func testLoadDataSuccess() {
        let mockService = createServiceMockWithSuccess()
        let viewModel = ListViewModel(networkService: mockService)
        let expectation = XCTestExpectation(description: "Successfully load data")
        
        viewModel.loadData()
        
        viewModel.$items
            .sink { items in
                XCTAssert(!items.isEmpty, "Items array should not be empty after success in loading")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testLoadDataFailure() {
        let mockService = createServiceMockWithError()
        let viewModel = ListViewModel(networkService: mockService)
        let expectation = XCTestExpectation(description: "Failed to load data")
        
        viewModel.loadData()
        
        viewModel.$items
            .sink { items in
                XCTAssertTrue(items.isEmpty, "Items array should be empty after failure in loading")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testInitialState() {
        let mockService = createServiceMockWithSuccess()
        let viewModel = ListViewModel(networkService: mockService)
        
        XCTAssertTrue(viewModel.categories.isEmpty)
        XCTAssertTrue(viewModel.items.isEmpty)
    }
}
