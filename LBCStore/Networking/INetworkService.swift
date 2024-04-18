//
//  INetworkService.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import Foundation
import Combine

public protocol INetworkService {
    func fetchListings() -> AnyPublisher<[Listing], NetworkError>
    func fetchCategories() -> AnyPublisher<[ListingCategory], NetworkError>
}

public enum NetworkError: Error {
    case urlError
    case decodingError(Error)
    case sessionError(Error)
    case unknownError
}
