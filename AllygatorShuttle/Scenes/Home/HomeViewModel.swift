//
//  HomeViewModel.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 19.03.2021.
//

import Foundation

protocol HomeViewDataSource {
    var rideFinishTitle: String { get }
    var errorTitle: String { get }
    var startTitle: String { get }
    var finishTitle: String { get }
}

protocol HomeViewEventSource {
    func showPopup(title: String, closeHandler: VoidClosure?)
}

protocol HomeViewProtocol: HomeViewDataSource, HomeViewEventSource {}

final class HomeViewModel: BaseViewModel<HomeRouter>, HomeViewProtocol {
    var startTitle: String = "Start ride"
    var finishTitle: String = "Finish ride"
    var rideFinishTitle: String = "Your ride is finished!"
    var errorTitle: String = "Somethhing went wrong!"
    
    func showPopup(title: String, closeHandler: VoidClosure?) {
        router.presentPopupView(closeHandler: closeHandler, title: title)
    }
}
