//
//  UIStackViewExtensionTest.swift
//  AllygatorShuttleTests
//
//  Created by Burak Kaya on 21.03.2021.
//

import XCTest
@testable import AllygatorShuttle

class UIStackViewExtensionTest: XCTestCase {
    
    func testAddArrangedSubviews() throws {
        // When:
        let button = UIButton()
        let label = UILabel()
        let stackView = UIStackView()

        // When:
        stackView.addArrangedSubviews([button,label])
        
        // Then:
        XCTAssertEqual(stackView.subviews.count, 2)
    }

}
