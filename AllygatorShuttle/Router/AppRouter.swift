//
//  AppRouter.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import Foundation
import UIKit

final class AppRouter: Router, AppRouter.Routes {
    
    typealias Routes = SplashRoute
    
    static let shared = AppRouter()
    
    func startApp() {
        pushSplash()
    }
}
