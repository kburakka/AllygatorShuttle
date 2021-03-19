//
//  HomeViewModel.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 19.03.2021.
//

import Foundation

protocol HomeViewDataSource {}

protocol HomeViewEventSource {
    func showRideFinishPopup(closeHandler: VoidClosure?)
}

protocol HomeViewProtocol: HomeViewDataSource, HomeViewEventSource {}

final class HomeViewModel: BaseViewModel<HomeRouter>, HomeViewProtocol {
    func showRideFinishPopup(closeHandler: VoidClosure?) {
        router.presentWalkFinishPopup(closeHandler: closeHandler)
    }
}
