//
//  MockListing.swift
//  LBCStoreTests
//
//  Created by Volhan Salai on 18/04/2024.
//

import Foundation
import LBCStore

struct MockListing {
    static func createMock() -> [Listing] {
        var listings = [Listing]()
        
        for i in 1...30 {
            let listing = Listing(
                id: i,
                categoryId: 100,
                title: "Mock Title",
                description: "Mock Description",
                price: 99.99,
                imagesUrl: ImagesURL(small: "http://example.com/small.jpg", thumb: "http://example.com/thumb.jpg"),
                creationDate: "2024-04-18T00:00:00Z",
                isUrgent: false
            )
            listings.append(listing)
        }
        
        return listings
    }
}
