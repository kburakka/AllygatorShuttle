//
//  AppRouter.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import Foundation
import UIKit

final class AppRouter: Router, AppRouter.Routes {
    // This typealias includes the routes which AppRouter can open
    typealias Routes = SplashRoute
    
    static let shared = AppRouter()
    
    func startApp() {
        pushSplash()
    }
}
