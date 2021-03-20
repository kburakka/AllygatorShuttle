//
//  RideFinishViewModel.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 20.03.2021.
//

import Foundation

protocol PopupViewDataSource {
    var title: String { get set }
    var buttonTitle: String { get set }
    var closeCompletion: VoidClosure? { get set }
}

protocol PopupViewEventSource {}

protocol PopupViewProtocol: PopupViewDataSource, PopupViewEventSource {}

final class PopupViewModel: BaseViewModel<PopupViewRouter>, PopupViewProtocol {
    var closeCompletion: VoidClosure?
    var title: String = ""
    var buttonTitle: String = "CLOSE"
    
    init(router: PopupViewRouter, closeCompletion: VoidClosure?, title: String) {
        self.closeCompletion = closeCompletion
        self.title = title
        super.init(router: router)
    }
}
