//
//  BaseViewModel.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import Foundation

protocol BaseViewModelDataSource: AnyObject { }

protocol BaseViewModelEventSource: AnyObject { }

protocol BaseViewModelProtocol: BaseViewModelDataSource, BaseViewModelEventSource {
    func showLoadingView()
    func hideLoadingView()
}

class BaseViewModel<R: Router>: BaseViewModelProtocol {
    private var hud = LoadingHelper("Loading")

    let router: R
    let socketManager: SocketManager
    
    init(router: R, socketManager: SocketManager = SocketManager.shared) {
        self.router = router
        self.socketManager = socketManager
    }
    
    func showLoadingView() {
        hud.showHUD()
    }
    
    func hideLoadingView() {
        hud.stopHUD()
    }
}
