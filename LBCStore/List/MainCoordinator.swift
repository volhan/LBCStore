//
//  MainCoordinator.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import UIKit

final class MainCoordinator: ICoordinator {
    weak var parentCoordinator: ICoordinator?
    var childCoordinators = [ICoordinator]()
    var navigationController: UINavigationController
    
    private let networkService: INetworkService
    
    init(navigationController: UINavigationController, networkService: INetworkService) {
        self.navigationController = navigationController
        self.networkService = networkService
    }
    
    func start() {
        let viewModel = ListViewModel(networkService: networkService)
        let listViewController = ListViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(listViewController, animated: false)
    }
}

extension MainCoordinator {
    func showListingDetailView(listing: Listing) {
        let viewModel = ListingViewModel(listing: listing)
        let coordinator = ListingCoordinator(navigationController: navigationController, viewModel: viewModel)
        
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
