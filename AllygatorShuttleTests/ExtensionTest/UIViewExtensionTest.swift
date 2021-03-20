//
//  UIViewExtensionTest.swift
//  AllygatorShuttleTests
//
//  Created by Burak Kaya on 21.03.2021.
//


import XCTest
@testable import AllygatorShuttle

class UIViewExtensionTest: XCTestCase {
    
    func testAddSubviews() throws {
        // When:
        let button = UIButton()
        let label = UILabel()
        let view = UIView()

        // When:
        view.addSubviews([button,label])
        
        // Then:
        XCTAssertEqual(view.subviews.count, 2)
    }
}
