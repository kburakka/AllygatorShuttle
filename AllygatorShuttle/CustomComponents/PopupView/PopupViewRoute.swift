//
//  RideFinishRoute.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 20.03.2021.
//

import Foundation

protocol PopupViewRoute {
    func presentPopupView(closeHandler: VoidClosure?, title: String)
}

extension PopupViewRoute where Self: RouterProtocol {
    
    func presentPopupView(closeHandler: VoidClosure?, title: String = "") {
        let router = PopupViewRouter()
        let viewModel = PopupViewModel(router: router, closeCompletion: closeHandler, title: title)
        let viewController = PopupViewController(viewModel: viewModel)
        
        let transition = ModalTransition()
        transition.modalPresentationStyle = .overFullScreen
        transition.modalTransitionStyle = .crossDissolve
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
    
}
