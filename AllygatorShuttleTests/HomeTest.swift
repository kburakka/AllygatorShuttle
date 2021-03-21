//
//  HomeTest.swift
//  AllygatorShuttleTests
//
//  Created by Burak Kaya on 20.03.2021.
//

import MapKit
import XCTest
@testable import AllygatorShuttle

class HomeTest: XCTestCase {

    private var view: HomeViewController!
    private var viewModel: HomeViewModel!
    private var socketManager: SocketManager!
    private var router: HomeRouter!

    override func setUpWithError() throws {
        socketManager = SocketManager.shared
        router = HomeRouter()
        viewModel = HomeViewModel(router: router, socketManager: socketManager)
        view = HomeViewController(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        socketManager = nil
        router = nil
        viewModel = nil
        view = nil
    }
    
    func testParseSocketEvent() throws {
        // When:
        let data = """
        {"event":"bookingOpened","data":{"status":"waitingForPickup","vehicleLocation":{"address":null,"lng":13.426789,"lat":52.519061},"pickupLocation":{"address":"Volksbühne Berlin","lng":13.411632,"lat":52.52663},"dropoffLocation":{"address":"Gendarmenmarkt","lng":13.393208,"lat":52.513763},"intermediateStopLocations":[{"address":"The Sixties Diner","lng":13.399356,"lat":52.523728},{"address":"Friedrichstraße Station","lng":13.388238,"lat":52.519485}]}}
        """
        view.mapView.removeAnnotations(view.mapView.annotations)

        // When:
        view.parseSocketEvent(socket: data)
        
        // Then:
        XCTAssertEqual(view.viewModel.isInRide, true)
        XCTAssertEqual(view.viewModel.socketButtonTitle, "Finish ride")
        if let status = Status.init(rawValue: "waitingForPickup") {
            XCTAssertEqual(view.viewModel.getStatusAlias(status: status), "Waiting for pickup!")
        } else {
            XCTFail("Status is nil")
        }
        XCTAssertEqual(view.mapView.annotations.count, 5)
    }
    
    func testSetWebSocket() throws {
        // When:
        view.setWebSocket()
        socketManager.eventClosure?(.connected(["test" : "test"]))
        
        // Then:
        XCTAssertEqual(view.viewModel.isConectWebSocket, true)
    }
    
    
    func testSetUpdateVehicle() throws {
        // Given:
        let address = Address(lat: 10.0, lng: 10.0, address: nil)
        view.mapView.removeAnnotations(view.mapView.annotations)

        // When:
        view.setUpdateVehicle(address)
        
        // Then:
        XCTAssertEqual(view.vehicleAnnotation.coordinate.latitude, address.lat)
        XCTAssertEqual(view.vehicleAnnotation.coordinate.longitude, address.lng)
        XCTAssertEqual(view.mapView.annotations.count, 1)
        XCTAssertEqual(view.viewModel.isFirstTimeVehicleUpdate, false)
    }
    
    func testSetBookingOpened() throws {
        // Given:
        let bookingOpenedData = BookingOpenedData(status: Status.inVehicle,
                                                  vehicleLocation: Address(lat: 10.0, lng: 10.0, address: nil),
                                                  pickupLocation:  Address(lat: 10.0, lng: 10.0, address: "Berlin"),
                                                  dropoffLocation:  Address(lat: 10.0, lng: 10.0, address: "Amsterdam"),
                                                  intermediateStopLocations: [Address(lat: 10.0, lng: 10.0, address: "Munich")])
        view.mapView.removeAnnotations(view.mapView.annotations)
        

        // When:
        view.setBookingOpened(bookingOpenedData)
        
        // Then:
        XCTAssertEqual(view.viewModel.isInRide, true)
        XCTAssertEqual(view.mapView.annotations.count, 4)
    }
    
    func testSetStations() throws {
        // Given:
        let addressList = [Address(lat: 10.0, lng: 10.0, address: "Berlin"),
                           Address(lat: 10.0, lng: 10.0, address: "Istanbul")]
        view.mapView.removeAnnotations(view.mapView.annotations)

        // When:
        view.setStations(addressList)
        
        // Then:
        XCTAssertEqual(view.mapView.annotations.count, 2)
        XCTAssertEqual(view.stationList.count, 2)

    }
    
    func testSetBookingClosed() throws {
        // Given:
        view.viewModel.isInRide = true

        // When:
        view.setBookingClosed()
        
        // Then:
        XCTAssertEqual(view.viewModel.isInRide, false)
    }
    
    func testHandleError() throws {
        // Given:
        view.viewModel.isInRide = true
        view.viewModel.isPopupDisplay = false

        // When:
        view.handleError(nil)
        
        // Then:
        XCTAssertEqual(view.viewModel.isInRide, false)
        XCTAssertEqual(view.viewModel.isPopupDisplay, true)
    }
    
    func testShowPupup() throws {
        // Given:
        view.viewModel.isPopupDisplay = false
        
        // When:
        view.showPopup(title: "title")
        
        // Then:
        XCTAssertEqual(view.viewModel.isPopupDisplay, true)
    }
}
