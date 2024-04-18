//
//  GithubUserContentService.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import Foundation
import Combine
import Foundation

enum GithubUserNetworkEndpoint {
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

final class GithubUserContentService: INetworkService {
    private var cache = NSCache<NSString, NSData>()
    
    private func fetch<T: Decodable>(endpoint: GithubUserNetworkEndpoint) -> AnyPublisher<T, NetworkError> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.urlError).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { NetworkError.sessionError($0) }
            .tryCatch { [weak self] (error) -> AnyPublisher<(data: Data, response: URLResponse), NetworkError> in
                guard let cachedData = self?.cache.object(forKey: url.absoluteString as NSString) as Data? else {
                    throw error
                }
                return Just((data: cachedData, response: URLResponse()))
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            }
            .map(\.data)
            .handleEvents(receiveOutput: { [weak self] data in
                self?.cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                (error as? NetworkError) ?? NetworkError.decodingError(error)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchListings() -> AnyPublisher<[Listing], NetworkError> {
        return fetch(endpoint: .listings)
    }
    
    func fetchCategories() -> AnyPublisher<[ListingCategory], NetworkError> {
        return fetch(endpoint: .categories)
    }
}
