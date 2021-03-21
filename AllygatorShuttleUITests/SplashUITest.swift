//
//  SplashUITest.swift
//  AllygatorShuttleUITests
//
//  Created by Burak Kaya on 21.03.2021.
//

import XCTest

class SplashUITest: XCTestCase {
    let app = XCUIApplication()
    override func setUpWithError() throws {
        app.launch()
        continueAfterFailure = false
    }
    
    func testSplashView() throws {
        XCTAssertTrue(app.splashViewController.exists)
    }
    
    func testExample() throws {
        XCTAssertTrue(app.homeViewController.waitForExistence(timeout: 2))
    }
}
