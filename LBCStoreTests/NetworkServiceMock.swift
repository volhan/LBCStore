//
//  NetworkServiceMock.swift
//  LBCStoreTests
//
//  Created by Volhan Salai on 18/04/2024.
//

import Foundation
import LBCStore
import Combine

class NetworkServiceSuccessMock: INetworkService {
    func fetchListings() -> AnyPublisher<[Listing], NetworkError> {
        return Just(MockListing.createMock()).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
    }
    
    func fetchCategories() -> AnyPublisher<[ListingCategory], NetworkError> {
        return Just(MockCategory.createMock()).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
    }
}

class NetworkServiceFailureMock: INetworkService {
    func fetchListings() -> AnyPublisher<[Listing], NetworkError> {
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
    
    func fetchCategories() -> AnyPublisher<[ListingCategory], NetworkError> {
        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
    }
}

public func createServiceMockWithSuccess() -> INetworkService {
    return NetworkServiceSuccessMock()
}

public func createServiceMockWithError() -> INetworkService {
    return NetworkServiceFailureMock()
}
