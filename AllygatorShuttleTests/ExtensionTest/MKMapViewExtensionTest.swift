//
//  MKMapViewExtensionTest.swift
//  AllygatorShuttleTests
//
//  Created by Burak Kaya on 21.03.2021.
//

import XCTest
import MapKit
@testable import AllygatorShuttle

class MKMapViewExtensionTest: XCTestCase {
    
    func testAddAnnotationIfNotExist() throws {
        // Given:
        let mapViewExist = MKMapView()
        let mapViewNotExist = MKMapView()
        let annotation = MKPointAnnotation()
        mapViewExist.addAnnotation(annotation)
        
        // When:
        mapViewExist.addAnnotationIfNotExist(annotation)
        mapViewNotExist.addAnnotationIfNotExist(annotation)

        // Then:
        XCTAssertEqual(mapViewExist.annotations.count, 1)
        XCTAssertEqual(mapViewNotExist.annotations.count, 1)
    }
    
    func testRemoveAllAnnotations() throws {
        // Given:
        let mapView = MKMapView()
        let annotation = MKPointAnnotation()
        mapView.addAnnotation(annotation)
        mapView.addAnnotation(annotation)
        
        // When:
        mapView.removeAllAnnotations()
        
        // Then:
        XCTAssertEqual(mapView.annotations.count, 0)
    }
}
