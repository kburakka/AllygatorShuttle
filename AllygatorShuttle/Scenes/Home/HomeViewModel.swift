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
    var socketButtonTitle: String { get }
    var isConectWebSocket: Bool { get set }
    var isPopupDisplay: Bool { get set }
    var isInRide: Bool { get set }
    var isInRideCompletion: BoolClosure? { get set }
    var isFirstTimeVehicleUpdate: Bool { get set }
    var lastVehicleAddress: Address? { get set }

    func getStatusAlias(status: Status) -> String
}

protocol HomeViewEventSource {
    func showPopup(title: String, closeHandler: VoidClosure?)
}

protocol HomeViewProtocol: HomeViewDataSource, HomeViewEventSource {}

final class HomeViewModel: BaseViewModel<HomeRouter>, HomeViewProtocol {
    var rideFinishTitle: String = "Your ride is finished!"
    var errorTitle: String = "Something went wrong!"
    var isConectWebSocket = false
    var isFirstTimeVehicleUpdate = true
    var isPopupDisplay = false
    var isInRideCompletion: BoolClosure?
    var lastVehicleAddress: Address?
    var socketButtonTitle: String {
        return isInRide ? "Finish ride" : "Start ride"
    }
    var isInRide = false {
        didSet {
            isInRideCompletion?(isInRide)
        }
    }
    
    func showPopup(title: String, closeHandler: VoidClosure?) {
        router.presentPopupView(closeHandler: closeHandler, title: title)
    }
    
    func getStatusAlias(status: Status) -> String {
        return status.getAlias()
    }
}
