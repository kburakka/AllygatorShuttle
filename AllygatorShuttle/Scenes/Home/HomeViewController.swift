//
//  HomeViewController.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 19.03.2021.
//

import UIKit
import MapKit
import Starscream

final class HomeViewController: BaseViewController<HomeViewModel> {
    
    private let mapView = MKMapView()
    private let cardView = UIView(backgroundColor: .white, cornerRadius: 19)
    private var isZoomBofore = false
    
    let vehicleAnnotation = CustomPointAnnotation(image: .imgVehicle)
    let startAnnotation = CustomPointAnnotation(image: .imgStart)
    let finishAnnotation = CustomPointAnnotation(image: .imgFinish)
    var stationList: [CustomPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        mapView.addAnnotation(vehicleAnnotation)
        mapView.addAnnotation(startAnnotation)
        mapView.addAnnotation(finishAnnotation)
        
        SocketManager.shared.connect()
        SocketManager.shared.eventClosure = { event in
            switch event {
            case .connected(let headers):
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                self.parseSocketEvent(socket: string)
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                print("ping")
            case .pong(_):
                print("pong")
            case .viabilityChanged(_):
                print("viabilityChanged")
            case .reconnectSuggested(_):
                print("reconnectSuggested")
            case .cancelled:
                print("cancelled")
            case .error(let error):
                print("error")
                self.handleError(error)
            }

        }
    }
    
    func handleError(_ error: Error?) {
        if let error = error as? WSError {
            print("websocket encountered an error: \(error.message)")
        } else if let error = error {
            print("websocket encountered an error: \(error.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    func parseSocketEvent(socket: String) {
        guard let data = socket.data(using: .utf8),
              let response = Socket(data: data) else {
            print("HATAAA")
            return
        }
        
        switch response.data {
        case .bookingOpenedData(let data):
            setBookingOpendLocation(data)
        case .vehicleLocationUpdated(let data):
            updateVehicleVlocation(CLLocationCoordinate2D(latitude: data.lat, longitude: data.lng))
        case .statusUpdated(let data):
            print(data.rawValue)
        case .intermediateStopLocationsChanged(let data):
            setStationsLocation(addressList: data)
        case .bookingClosed(let data):
            print(data)
        case .none:
            print("boss")
        }
    }
    
    func updateVehicleVlocation(_ location: CLLocationCoordinate2D) {
        vehicleAnnotation.coordinate = location
        
        if !isZoomBofore {
            isZoomBofore = true
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    func setBookingOpendLocation(_ data: BookingOpenedData) {
        let pickupLocation = data.pickupLocation
        let dropoffLocation = data.dropoffLocation

        startAnnotation.coordinate = CLLocationCoordinate2D(latitude: pickupLocation.lat, longitude: pickupLocation.lng)
        
        finishAnnotation.coordinate = CLLocationCoordinate2D(latitude: dropoffLocation.lat, longitude: dropoffLocation.lng)
        
        setStationsLocation(addressList: data.intermediateStopLocations)
    }
    
    func setStationsLocation(addressList: [Address?]) {
        mapView.removeAnnotations(stationList)
        stationList = []
        addressList.forEach({
            if let address = $0 {
                let stationAnnotation = CustomPointAnnotation(image: .imgStation)
                stationAnnotation.coordinate = CLLocationCoordinate2D(latitude: address.lat, longitude: address.lng)
                stationAnnotation.title = address.address
                mapView.addAnnotation(stationAnnotation)
                stationList.append(stationAnnotation)
            }
        })
    }
    
    override func setupViews() {
        cardView.height(150)
        view.addSubviews([mapView, cardView])
    }
    
    override func setupLayouts() {
        mapView.edgesToSuperview(excluding: .bottom)
        mapView.bottomToTop(of: cardView, offset: 20)
        cardView.edgesToSuperview(excluding: .top,
                                  insets: UIEdgeInsets(top: 0,
                                                       left: 0,
                                                       bottom: 20,
                                                       right: 0),
                                  usingSafeArea: false)
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let cpa = annotation as? CustomPointAnnotation
        let annotationView = MKPinAnnotationView(annotation: vehicleAnnotation, reuseIdentifier: "customView")
        annotationView.canShowCallout = true
        annotationView.image = cpa?.image

        return annotationView
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    var image: UIImage?
    
    init(image: UIImage?) {
        self.image = image?.resize(targetSize: CGSize(width: 50, height: 50))
    }
    
}
