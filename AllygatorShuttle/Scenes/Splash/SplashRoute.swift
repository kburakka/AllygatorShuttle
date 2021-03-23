//
//  SplashRoute.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import UIKit

protocol SplashRoute {
    func pushSplash()
}

extension SplashRoute where Self: RouterProtocol {
    
    /// Thins opens Splash screem
    func pushSplash() {
        let router = SplashRouter()
        let viewModel = SplashViewModel(router: router)
        let viewController = SplashViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)

        let transition = PlaceOnWindowTransition()
        router.viewController = viewController
        router.openTransition = transition
        
        open(navigationController, transition: transition)
    }
}
