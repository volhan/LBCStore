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
    private var networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkServiceProtocol) {
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
            })
            .store(in: &cancellables)
    }
    
    func getCategoryName(for categoryId: Int) -> String {
        categories.first { $0.id == categoryId }?.name ?? "Unknown"
    }
}
