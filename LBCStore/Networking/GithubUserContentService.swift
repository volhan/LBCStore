//
//  GithubUserContentService.swift
//  LBCStore
//
//  Created by Volhan Salai on 30/01/2024.
//

import Combine
import Foundation

protocol NetworkServiceProtocol {
    func fetchListings() -> AnyPublisher<[Listing], NetworkError>
    func fetchCategories() -> AnyPublisher<[Category], NetworkError>
}

enum NetworkError: Error {
    case urlError
    case decodingError(Error)
    case sessionError(Error)
}

enum GithubUserContentEndpoint {
    case listings
    case categories
    
    var url: URL? {
        let baseURL = "https://raw.githubusercontent.com/leboncoin/paperclip/master"
        switch self {
        case .listings:
            return URL(string: "\(baseURL)/listing.json")
        case .categories:
            return URL(string: "\(baseURL)/categories.json")
        }
    }
}

class GithubUserContentService: NetworkServiceProtocol {
    private func fetch<T: Decodable>(endpoint: GithubUserContentEndpoint) -> AnyPublisher<T, NetworkError> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.urlError).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { NetworkError.sessionError($0) }
            .flatMap { data, _ in
                Just(data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { NetworkError.decodingError($0) }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchListings() -> AnyPublisher<[Listing], NetworkError> {
        return fetch(endpoint: .listings)
    }
    
    func fetchCategories() -> AnyPublisher<[Category], NetworkError> {
        return fetch(endpoint: .categories)
    }
}
