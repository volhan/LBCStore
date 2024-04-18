//
//  ListingCellViewModel.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import Foundation

final class ListingCellViewModel {
    let title: String
    let imageUrl: URL?
    let date: String?
    let price: String
    let isUrgent: Bool
    
    init(listing: Listing) {
        self.title = listing.title
        self.price = String(format: "%.0f €", listing.price)
        self.isUrgent = listing.isUrgent
        self.imageUrl = URL(string: listing.imagesUrl.small ?? listing.imagesUrl.thumb ?? "")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: listing.creationDate) {
            formatter.dateFormat = "dd.MM.yyyy"
            self.date = formatter.string(from: date)
        } else {
            self.date = nil
            Logger.logError(Strings.ErrorMessages.dateFormatError)
        }
    }
}
