//
//  AppDelegate.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)
        self.window?.makeKeyAndVisible()
        AppRouter.shared.startApp()
        
        startWithArgument()
        
        return true
    }
    
    /// This disable Animations. This is using while UITest
    func startWithArgument() {
        let arguments = ProcessInfo.processInfo.arguments
        
        for argument in arguments {
            switch argument {
            case Constants.noAnimations:
                UIView.setAnimationsEnabled(false)
            default:
                break
            }
        }
    }
}
