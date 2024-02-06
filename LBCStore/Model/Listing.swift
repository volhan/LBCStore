//
//  Listing.swift
//  LBCStore
//
//  Created by Volhan Salai on 30/01/2024.
//

import Foundation

struct Listing: Codable {
    let id: Int
    let categoryId: Int
    let title: String
    let description: String
    let price: Double
    let imagesUrl: ImagesURL
    let creationDate: String
    let isUrgent: Bool
    
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

struct Category: Codable {
    let id: Int
    let name: String
}

struct ImagesURL: Codable {
    let small: String?
    let thumb: String?
}
