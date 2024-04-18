//
//  ListViewModel.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import Foundation
import Combine

final class ListViewModel {
    private var networkService: INetworkService
    private var cancellables = Set<AnyCancellable>()
    @Published private var allItems: [Listing] = []
    @Published var items: [Listing] = []
    var categories: [ListingCategory] = []
    
    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    func loadData() {
        networkService.fetchCategories()
            .flatMap { [weak self] categories -> AnyPublisher<[Listing], NetworkError> in
                self?.categories = categories
                return self?.networkService.fetchListings() ?? Empty().eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    Logger.logError(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] listings in
                self?.items = listings.sorted {
                    if $0.isUrgent == $1.isUrgent {
                        return $0.creationDate > $1.creationDate
                    }
                    return $0.isUrgent && !$1.isUrgent
                }
                
                self?.allItems = self?.items ?? []
            })
            .store(in: &cancellables)
    }
    
    func filterItems(by category: ListingCategory) {
        items = allItems.filter { $0.categoryId == category.id }
    }
    
    func clearFilter() {
        items = allItems
    }
}
