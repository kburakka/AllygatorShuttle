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
    
    var socketButton: XCUIElement {
        return buttons["socketButton"]
    }
    
    var detailButton: XCUIElement {
        return buttons["detailButton"]
    }
    
    var pickupDetailView: XCUIElement {
        return otherElements["pickupDetailView"]
    }
    
    var dropoffDetailView: XCUIElement {
        return otherElements["dropoffDetailView"]
    }
}
