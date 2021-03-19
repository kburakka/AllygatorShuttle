//
//  RideFinishViewModel.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 20.03.2021.
//

import Foundation

protocol RideFinishViewDataSource {
    var title: String { get set }
    var buttonTitle: String { get set }
    var closeCompletion: VoidClosure? { get set }
}

protocol RideFinishViewEventSource {}

protocol RideFinishViewProtocol: RideFinishViewDataSource, RideFinishViewEventSource {}

final class RideFinishViewModel: BaseViewModel<RideFinishRouter>, RideFinishViewProtocol {
    var closeCompletion: VoidClosure?
    var title: String = "Your ride is finished!"
    var buttonTitle: String = "CLOSE"
    
    init(router: RideFinishRouter, closeCompletion: VoidClosure?) {
        self.closeCompletion = closeCompletion
        super.init(router: router)
    }
}
