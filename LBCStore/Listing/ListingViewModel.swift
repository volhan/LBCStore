//
//  ListingViewModel.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import Foundation

final class ListingViewModel {
    private let listing: Listing
    
    var title: String {
        listing.title
    }
    
    var description: String {
        listing.description
    }
    
    var price: String {
        String(format: "%.0f €", listing.price)
    }
    
    var imageUrl: URL? {
        URL(string: listing.imagesUrl.thumb ?? listing.imagesUrl.small ?? "")
    }
    
    var isUrgent: Bool {
        listing.isUrgent
    }
    
    init(listing: Listing) {
        self.listing = listing
    }
}
