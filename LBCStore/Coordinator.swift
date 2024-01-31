//
//  Coordinator.swift
//  LBCStore
//
//  Created by Volhan Salai on 30/01/2024.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start()
}
