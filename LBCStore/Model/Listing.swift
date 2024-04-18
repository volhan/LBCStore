//
//  Listing.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import Foundation

public struct Listing: Decodable {
    let id: Int
    let categoryId: Int
    let title: String
    let description: String
    let price: Double
    let imagesUrl: ImagesURL
    let creationDate: String
    let isUrgent: Bool
    
    public init(id: Int, categoryId: Int, title: String, description: String, price: Double, imagesUrl: ImagesURL, creationDate: String, isUrgent: Bool) {
        self.id = id
        self.categoryId = categoryId
        self.title = title
        self.description = description
        self.price = price
        self.imagesUrl = imagesUrl
        self.creationDate = creationDate
        self.isUrgent = isUrgent
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case title
        case description
        case price
        case imagesUrl = "images_url"
        case creationDate = "creation_date"
        case isUrgent = "is_urgent"
    }
}

public struct ImagesURL: Decodable {
    let small: String?
    let thumb: String?
    
    public init(small: String?, thumb: String?) {
        self.small = small
        self.thumb = thumb
    }
}
