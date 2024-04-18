//
//  ListingViewModel.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import Foundation

final class ListingViewModel {
    private let listing: Listing
    private let categories: [ListingCategory]
    
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
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: listing.creationDate) {
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: date)
        } else {
            Logger.logError(Strings.ErrorMessages.dateFormatError)
            return ""
        }
    }
    
    var category: String {
        categories.first(where: { $0.id == listing.categoryId })?.name ?? ""
    }
    
    init(listing: Listing, categories:  [ListingCategory]) {
        self.listing = listing
        self.categories = categories
    }
}
