//
//  SplashViewController.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import UIKit
import Starscream

final class SplashViewController: BaseViewController<SplashViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        SocketManager.shared.connect()
    }
    
}
