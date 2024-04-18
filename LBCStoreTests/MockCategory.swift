//
//  MockCategory.swift
//  LBCStoreTests
//
//  Created by Volhan Salai on 18/04/2024.
//

import Foundation
import LBCStore

struct MockCategory {
    static func createMock() -> [ListingCategory] {
        return [
            ListingCategory(id: 1, name: "Véhicule"),
            ListingCategory(id: 2, name: "Mode"),
            ListingCategory(id: 3, name: "Bricolage"),
            ListingCategory(id: 4, name: "Maison"),
            ListingCategory(id: 5, name: "Loisirs"),
            ListingCategory(id: 6, name: "Immobilier"),
            ListingCategory(id: 7, name: "Livres/CD/DVD"),
            ListingCategory(id: 8, name: "Multimédia"),
            ListingCategory(id: 9, name: "Service"),
            ListingCategory(id: 10, name: "Animaux"),
            ListingCategory(id: 11, name: "Enfants")
        ]
    }
}
