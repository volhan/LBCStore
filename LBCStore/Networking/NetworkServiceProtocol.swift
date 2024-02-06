//
//  NetworkServiceProtocol.swift
//  LBCStore
//
//  Created by Volhan Salai on 05/02/2024.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchListings() -> AnyPublisher<[Listing], NetworkError>
    func fetchCategories() -> AnyPublisher<[Category], NetworkError>
}

enum NetworkError: Error {
    case urlError
    case decodingError(Error)
    case sessionError(Error)
}
