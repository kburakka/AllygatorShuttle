//
//  HomeUITest.swift
//  AllygatorShuttleUITests
//
//  Created by Burak Kaya on 21.03.2021.
//

import XCTest
@testable import AllygatorShuttle

class HomeUITest: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        app.launch()
        continueAfterFailure = false
    }
    
    func testLoadingView() throws {
        sleep(2)
        app.buttons["socketButton"].tap()
        XCTAssertTrue(app.loadingLottie.exists)
    }
}
