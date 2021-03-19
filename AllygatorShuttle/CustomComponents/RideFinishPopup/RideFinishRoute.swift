//
//  RideFinishRoute.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 20.03.2021.
//


import Foundation

protocol RideFinishRoute {
    func presentWalkFinishPopup(closeHandler: VoidClosure?)
}

extension RideFinishRoute where Self: RouterProtocol {
    
    func presentWalkFinishPopup(closeHandler: VoidClosure?) {
        let router = RideFinishRouter()
        let viewModel = RideFinishViewModel(router: router, closeCompletion: closeHandler)
        let viewController = RideFinishViewController(viewModel: viewModel)
        
        let transition = ModalTransition()
        transition.modalPresentationStyle = .overFullScreen
        transition.modalTransitionStyle = .crossDissolve
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
    
}
