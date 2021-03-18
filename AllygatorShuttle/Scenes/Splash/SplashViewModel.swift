//
//  SplashViewModel.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import Foundation

protocol SplashViewDataSource {}

protocol SplashViewEventSource {}

protocol SplashViewProtocol: SplashViewDataSource, SplashViewEventSource {}

final class SplashViewModel: BaseViewModel<SplashRouter>, SplashViewProtocol {
    
}
