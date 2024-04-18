//
//  SceneDelegate.swift
//  LBCStore
//
//  Created by Volhan Salai on 13/04/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var mainCoordinator: MainCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let navigationController = UINavigationController()
        let networkService = GithubUserContentService()
        mainCoordinator = MainCoordinator(navigationController: navigationController, networkService: networkService)
        mainCoordinator?.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
