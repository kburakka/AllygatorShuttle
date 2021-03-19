//
//  SplashViewModel.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import UIKit

protocol SplashViewDataSource {
    var logoImage: UIImage { get }
}

protocol SplashViewEventSource {
    func showHomeScreen()
}

protocol SplashViewProtocol: SplashViewDataSource, SplashViewEventSource {}

final class SplashViewModel: BaseViewModel<SplashRouter>, SplashViewProtocol {
    var logoImage: UIImage = .imgLogo
    
    func showHomeScreen() {
        router.pushHome()
    }
}
