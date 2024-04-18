//
//  Category.swift
//  LBCStore
//
//  Created by Volhan Salai on 18/04/2024.
//

import Foundation

public struct ListingCategory: Decodable {
    let id: Int
    let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
