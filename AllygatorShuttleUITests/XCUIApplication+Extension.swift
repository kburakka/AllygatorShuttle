//
//  XCUIApplication+Extension.swift
//  AllygatorShuttleUITests
//
//  Created by Burak Kaya on 21.03.2021.
//

import XCTest

extension XCUIApplication {
    var splashViewController: XCUIElement {
        return otherElements["SplashViewController"]
    }
    
    var homeViewController: XCUIElement {
        return otherElements["HomeViewController"]
    }
    
    var popupViewController: XCUIElement {
        return otherElements["PopupViewController"]
    }

    var loadingLottie: XCUIElement {
        return otherElements["LoadingLottie"]
    }
}
