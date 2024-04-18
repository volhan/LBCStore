//
//  ListingCoordinator.swift
//  LBCStore
//
//  Created by Volhan Salai on 18/04/2024.
//

import Foundation
import UIKit

final class ListingCoordinator: ICoordinator {
    weak var parentCoordinator: ICoordinator?
    var childCoordinators: [ICoordinator] = []
    var navigationController: UINavigationController
    
    private let viewModel: ListingViewModel
    
    init(navigationController: UINavigationController, viewModel: ListingViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let listingViewController = ListingViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(listingViewController, animated: true)
    }
}
