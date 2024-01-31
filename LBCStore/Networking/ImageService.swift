//
//  ImageService.swift
//  LBCStore
//
//  Created by Volhan Salai on 30/01/2024.
//

import Combine
import UIKit

enum ImageLoadingError: Error {
    case invalidImageData
    case networkError(Error)
}

class ImageLoader {
    static func loadImage(from url: URL) -> AnyPublisher<UIImage?, ImageLoadingError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> UIImage? in
                guard let image = UIImage(data: result.data) else {
                    throw ImageLoadingError.invalidImageData
                }
                return image
            }
            .mapError { error -> ImageLoadingError in
                if let urlError = error as? URLError {
                    return .networkError(urlError)
                } else {
                    return .invalidImageData
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
