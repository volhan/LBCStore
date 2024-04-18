//
//  ImageService.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import Combine
import UIKit

enum ImageLoadingError: Error {
    case invalidImageData
    case networkError(Error)
}

final class ImageLoader {
    private static var cache = NSCache<NSURL, UIImage>()
    private static var cancellables = [URL: AnyCancellable]()
    
    static func loadImage(from url: URL) -> AnyPublisher<UIImage?, ImageLoadingError> {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return Just(cachedImage).setFailureType(to: ImageLoadingError.self).eraseToAnyPublisher()
        }
        
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data -> UIImage? in
                guard let image = UIImage(data: data) else {
                    throw ImageLoadingError.invalidImageData
                }
                cache.setObject(image, forKey: url as NSURL)
                return image
            }
            .mapError { error -> ImageLoadingError in
                if let urlError = error as? URLError {
                    return .networkError(urlError)
                } else {
                    return .invalidImageData
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        cancellables[url] = publisher
            .sink(receiveCompletion: { _ in cancellables.removeValue(forKey: url) },
                  receiveValue: { _ in })
        
        return publisher
    }
}
