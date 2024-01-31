//
//  ListViewModel.swift
//  LBCStore
//
//  Created by Volhan Salai on 30/01/2024.
//

import Combine
import Foundation

class ListViewModel {
    @Published var items: [Listing] = []
    private var categories: [Category] = []
    private var contentService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(contentService: NetworkServiceProtocol) {
        self.contentService = contentService
    }
    
    func loadData() {
        contentService.fetchCategories()
            .flatMap { [weak self] categories -> AnyPublisher<[Listing], Error> in
                self?.categories = categories
                return self?.contentService.fetchListings() ?? Empty().eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] listings in
                self?.items = listings.sorted { $0.isUrgent && !$1.isUrgent || $0.creationDate > $1.creationDate }
            })
            .store(in: &cancellables)
    }
    
    func getCategoryName(for categoryId: Int) -> String {
        categories.first { $0.id == categoryId }?.name ?? "Unknown"
    }
}
