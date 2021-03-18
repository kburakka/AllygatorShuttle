//
//  SplashRoute.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

protocol SplashRoute {
    func pushSplash()
}

extension SplashRoute where Self: RouterProtocol {
    
    func pushSplash() {
        let router = SplashRouter()
        let viewModel = SplashViewModel(router: router)
        let viewController = SplashViewController(viewModel: viewModel)
        
        let transition = PushTransition()
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
}
