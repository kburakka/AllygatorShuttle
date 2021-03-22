//
//  HomeUITest.swift
//  AllygatorShuttleUITests
//
//  Created by Burak Kaya on 21.03.2021.
//

import XCTest

class HomeUITest: XCTestCase {
    let app: XCUIApplication = {
        let app = XCUIApplication()
        app.launchArguments = ["NoAnimations"]
        return app
    }()
    
    override func setUpWithError() throws {
        app.launch()
        continueAfterFailure = false
    }
    
    func testSocketButtonAction() throws {
        app.socketButton.tap()
        XCTAssertTrue(app.loadingLottie.exists)
    }
    
    func testDetailButtonAction() throws {
        app.socketButton.tap()
        XCTAssertTrue(app.loadingLottie.exists)
        
        XCTAssertTrue(!app.loadingLottie.waitForExistence(timeout: 10))

        app.detailButton.tap()
        XCTAssertTrue(app.pickupDetailView.exists)
        XCTAssertTrue(app.dropoffDetailView.exists)

        app.detailButton.tap()
        XCTAssertTrue(!app.pickupDetailView.exists)
        XCTAssertTrue(!app.dropoffDetailView.exists)
    }
}
