//
//  HomeRoute.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 19.03.2021.
//

protocol HomeRoute {
    func pushHome()
}

extension HomeRoute where Self: RouterProtocol {
    
    /// Thins opens Home screem
    func pushHome() {
        let router = HomeRouter()
        let viewModel = HomeViewModel(router: router)
        let viewController = HomeViewController(viewModel: viewModel)
        
        let transition = PushTransition()
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
}
