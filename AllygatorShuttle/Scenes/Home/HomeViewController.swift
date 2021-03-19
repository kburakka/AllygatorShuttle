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
    private lazy var cardView: UIView = {
        let view = UIView(backgroundColor: .white, cornerRadius: 19)
        view.addShadow(radius: 14,
                       offset: CGSize(width: 0, height: -9),
                       opacity: 0.2)
        return view
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 6
        button.titleLabel?.font = .mavenProRegularLarge
        button.backgroundColor = .darkGray
        button.setTitle("Start Journey", for: .normal)
        button.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        return button
    }()
    
    private let vehicleAnnotation = BaseAnnotation(image: .imgVehicle)
    private let startAnnotation = BaseAnnotation(image: .imgStart)
    private let finishAnnotation = BaseAnnotation(image: .imgFinish)
    private var stationList: [BaseAnnotation] = []
    private var isFirstVehicleUpdate = true
    
    private var isInRide = false {
        didSet {
            if !isInRide {
                removeAllAnnotations()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        viewModel.showRideFinishPopup {
            if let popupView = UIApplication.topViewController() {
                popupView.dismiss(animated: true)
            }
        }
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
            isInRide = true
            setBookingOpendLocation(data)
        case .vehicleLocationUpdated(let data):
            updateVehicleVlocation(CLLocationCoordinate2D(latitude: data.lat, longitude: data.lng))
        case .statusUpdated(let data):
            print(data.rawValue)
        case .intermediateStopLocationsChanged(let data):
            setStationsLocation(addressList: data)
        case .bookingClosed:
            isInRide = false
        case .none:
            isInRide = false
        }
    }
    
    func updateVehicleVlocation(_ location: CLLocationCoordinate2D) {
        vehicleAnnotation.coordinate = location
        
        if isFirstVehicleUpdate {
            isFirstVehicleUpdate = false
            mapView.addAnnotationIfNotExist(vehicleAnnotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
//    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
//
//        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
//        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
//
//        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
//        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
//
//        let dLon = lon2 - lon1
//
//        let y = sin(dLon) * cos(lat2)
//        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
//        let radiansBearing = atan2(y, x)
//
//        return radiansToDegrees(radians: radiansBearing)
//    }
//
    func setBookingOpendLocation(_ data: BookingOpenedData) {
        let pickupLocation = data.pickupLocation
        let dropoffLocation = data.dropoffLocation

        startAnnotation.coordinate = CLLocationCoordinate2D(latitude: pickupLocation.lat, longitude: pickupLocation.lng)
        finishAnnotation.coordinate = CLLocationCoordinate2D(latitude: dropoffLocation.lat, longitude: dropoffLocation.lng)
        
        mapView.addAnnotationIfNotExist(startAnnotation)
        mapView.addAnnotationIfNotExist(finishAnnotation)
        
        setStationsLocation(addressList: data.intermediateStopLocations)
    }
    
    func setStationsLocation(addressList: [Address?]) {
        mapView.removeAnnotations(stationList)
        stationList = []
        addressList.forEach({
            if let address = $0 {
                let stationAnnotation = BaseAnnotation(image: .imgStation)
                stationAnnotation.coordinate = CLLocationCoordinate2D(latitude: address.lat, longitude: address.lng)
                stationAnnotation.title = address.address
                mapView.addAnnotation(stationAnnotation)
                stationList.append(stationAnnotation)
            }
        })
    }
    
    override func setupViews() {
        startButton.height(44)
        startButton.width(120)
        cardView.height(150)
        cardView.addSubviews([startButton])
        view.addSubviews([mapView, cardView])
    }
    
    override func setupLayouts() {
        mapView.edgesToSuperview(excluding: .bottom)
        mapView.bottomToTop(of: cardView, offset: 20)
        
        startButton.centerInSuperview()
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
        let cpa = annotation as? BaseAnnotation
        let annotationView = MKPinAnnotationView(annotation: vehicleAnnotation, reuseIdentifier: "customView")
        annotationView.canShowCallout = true
        annotationView.image = cpa?.image

        return annotationView
    }
}

// MARK: - Helper
private extension HomeViewController {
    func removeAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
}

// MARK: - Action
@objc
private extension HomeViewController {
    func startAction() {
        SocketManager.shared.connect()
    }
}
