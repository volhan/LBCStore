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
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                guard let image = UIImage(data: data) else {
                    throw ImageLoadingError.invalidImageData
                }
                return image
            }
            .mapError(ImageLoadingError.networkError)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
