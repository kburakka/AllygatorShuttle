//
//  HomeViewModel.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 19.03.2021.
//

import Foundation

protocol HomeViewDataSource {
    var errorTitle: String { get }
    var rideFinishTitle: String { get }
    var socketButtonTitle: String { get }
    var detailButtonTitle: String { get }
    var isConectWebSocket: Bool { get set }
    var isPopupDisplay: Bool { get set }
    var isInRide: Bool { get set }
    var isInRideCompletion: BoolClosure? { get set }
    var isFirstTimeVehicleUpdate: Bool { get set }
    var lastVehicleAddress: Address? { get set }

    func getStatusAlias(status: Status) -> String
}

protocol HomeViewEventSource {
    func showPopupView(title: String, closeHandler: VoidClosure?)
}

protocol HomeViewProtocol: HomeViewDataSource, HomeViewEventSource {}

final class HomeViewModel: BaseViewModel<HomeRouter>, HomeViewProtocol {
    var isFirstTimeVehicleUpdate = true
    var isConectWebSocket = false
    var isDetailDisplay = false
    var isPopupDisplay = false
    var isInRideCompletion: BoolClosure?
    var lastVehicleAddress: Address?
    var rideFinishTitle: String = "Your ride is finished!"
    var errorTitle: String = "Something went wrong!"
    var detailButtonTitle: String {
        return isDetailDisplay ? "Hide Detail" : "Show Detail"
    }
    var socketButtonTitle: String {
        return isInRide ? "Finish Ride" : "Start Ride"
    }
    var isInRide = false {
        didSet {
            isInRideCompletion?(isInRide)
        }
    }
    
    func showPopupView(title: String, closeHandler: VoidClosure?) {
        router.presentPopupView(closeHandler: closeHandler, title: title)
    }
    
    func getStatusAlias(status: Status) -> String {
        return status.getAlias()
    }
    
    /// This will revert the variables to their original state
    func setDefaultModel() {
        isFirstTimeVehicleUpdate = true
        isConectWebSocket = false
        isDetailDisplay = false
        lastVehicleAddress = nil
        isInRide = false
    }
}
