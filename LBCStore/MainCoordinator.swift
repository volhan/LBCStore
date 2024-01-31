//
//  MainCoordinator.swift
//  LBCStore
//
//  Created by Volhan Salai on 30/01/2024.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ListViewModel(networkService: GithubUserContentService())
        let listViewController = ListViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(listViewController, animated: false)
    }
    
    func showListingDetailView(listing: Listing) {
        let viewModel = ListingViewModel(listing: listing)
        let listingViewController = ListingViewController(viewModel: viewModel)
        navigationController.pushViewController(listingViewController, animated: true)
    }
}
