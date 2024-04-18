//
//  ICoordinator.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import Foundation
import UIKit

protocol ICoordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var parentCoordinator: ICoordinator? { get set }
    var childCoordinators: [ICoordinator] { get set }
    
    func start()
}

extension ICoordinator {
    func addChildCoordinator(_ childCoordinator: ICoordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: ICoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}
