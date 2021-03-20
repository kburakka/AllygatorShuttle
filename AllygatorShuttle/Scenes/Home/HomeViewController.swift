//
//  HomeViewController.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 19.03.2021.
//

import UIKit
import MapKit
import Starscream

protocol HomeViewControllerProtocol {
    var mapView: MKMapView { get }
    var cardView: UIView { get }
    var socketButton: UIButton { get }
    var statusLabel: UILabel { get }
    var stackView: UIStackView { get }
    var vehicleAnnotation: BaseAnnotation { get }
    var pickupAnnotation: BaseAnnotation { get }
    var dropoffAnnotation: BaseAnnotation { get }
    var isFirstTimeVehicleUpdate: Bool { get set }
    var isInRide: Bool { get set }
    var stationList: [BaseAnnotation] { get set }
    var isConectWebSocket: Bool { get set }

    func setWebSocket()
    func parseSocketEvent(socket: String)
    func setUpdateVehicle(_ address: Address)
    func setBookingOpened(_ data: BookingOpenedData)
    func setStations(_ addressList: [Address?])
    func handleError(_ error: Error?)
    func showPopup(title: String)
    func setBookingClosed()
}

final class HomeViewController: BaseViewController<HomeViewModel>, HomeViewControllerProtocol {
    var mapView = MKMapView()
    var vehicleAnnotation = BaseAnnotation(image: .imgVehicle)
    var pickupAnnotation = BaseAnnotation(image: .imgStart)
    var dropoffAnnotation = BaseAnnotation(image: .imgFinish)
    var isConectWebSocket = false
    var isFirstTimeVehicleUpdate = true
    var stationList: [BaseAnnotation] = []
    
    
    var cardView: UIView = {
        let view = UIView(backgroundColor: .white, cornerRadius: 19)
        view.addShadow(radius: 14,
                       offset: CGSize(width: 0, height: -9),
                       opacity: 0.2)
        return view
    }()
    
    lazy var socketButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 6
        button.titleLabel?.font = .mavenProMediumLarge
        button.backgroundColor = .coal
        button.titleLabel?.textColor = .calcite
        button.setTitle(viewModel.startTitle, for: .normal)
        button.addTarget(self, action: #selector(socketAction), for: .touchUpInside)
        return button
    }()
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .mavenProMediumXXLarge
        label.textColor = .coal
        return label
    }()
    
    lazy var stackView: UIStackView = {
        return UIStackView(arrangedSubviews: [statusLabel,
                                              socketButton],
                           axis: .vertical,
                           spacing: 15,
                           alignment: .center,
                           distribution: .fill)
    }()
    
    var isInRide = false {
        didSet {
            if isInRide {
                socketButton.setTitle(viewModel.finishTitle, for: .normal)
            } else {
                isFirstTimeVehicleUpdate = true
                statusLabel.text = nil
                socketButton.setTitle(viewModel.startTitle, for: .normal)
                mapView.removeAllAnnotations()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setWebSocket()
    }
    
    override func setupViews() {
        socketButton.height(44)
        socketButton.width(120)
        cardView.addSubview(stackView)
        view.addSubviews([mapView, cardView])
    }
    
    override func setupLayouts() {
        mapView.edgesToSuperview(excluding: .bottom)
        mapView.bottomToTop(of: cardView, offset: 20)
        
        stackView.edgesToSuperview(insets: .init(top: 20, left: 20, bottom: 20, right: 20))
        cardView.edgesToSuperview(excluding: .top,
                                  insets: .init(top: 0,
                                                left: 0,
                                                bottom: 20,
                                                right: 0),
                                  usingSafeArea: false)
    }
}

// MARK: - MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let baseAnnotation = annotation as? BaseAnnotation
        let annotationView = MKPinAnnotationView(annotation: vehicleAnnotation, reuseIdentifier: "customView")
        annotationView.image = baseAnnotation?.image
        annotationView.canShowCallout = true

        return annotationView
    }
}

// MARK: - Helper
extension HomeViewController {
    func setWebSocket() {
        viewModel.socketManager.eventClosure = { event in
            guard let event = event else {
                self.isInRide = false
                self.viewModel.hideLoading()
                self.showPopup(title: self.viewModel.errorTitle)
                return
            }
            switch event {
            case .connected:
                self.isConectWebSocket = true
                self.viewModel.hideLoading()
            case .disconnected:
                self.isConectWebSocket = false
                self.viewModel.hideLoading()
            case .text(let string):
                self.parseSocketEvent(socket: string)
            case .cancelled:
                self.isInRide = false
                self.viewModel.hideLoading()
                self.showPopup(title: self.viewModel.rideFinishTitle)
            case .error(let error):
                self.handleError(error)
            default:
                break
            }
        }
    }
    
    func parseSocketEvent(socket: String) {
        guard let data = socket.data(using: .utf8),
              let response = Socket(data: data) else {
            isInRide = false
            viewModel.hideLoading()
            showPopup(title: viewModel.errorTitle)
            return
        }
        
        switch response.data {
        case .bookingOpenedData(let data):
            setBookingOpened(data)
        case .vehicleLocationUpdated(let data):
            setUpdateVehicle(data)
        case .statusUpdated(let data):
            statusLabel.text = data.getAlias()
        case .intermediateStopLocationsChanged(let data):
            setStations(data)
        case .bookingClosed:
            setBookingClosed()
        }
    }
    
    func setUpdateVehicle(_ address: Address) {
        vehicleAnnotation.coordinate = CLLocationCoordinate2D(latitude: address.lat, longitude: address.lng)
        
        if isFirstTimeVehicleUpdate {
            isFirstTimeVehicleUpdate = false
            mapView.addAnnotationIfNotExist(vehicleAnnotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    func setBookingOpened(_ data: BookingOpenedData) {
        isInRide = true
        statusLabel.text = data.status.getAlias()
        
        let pickupLocation = data.pickupLocation
        let pickupAddress = data.pickupLocation.address
        let dropoffLocation = data.dropoffLocation
        let dropoffAddress = data.dropoffLocation.address

        pickupAnnotation.coordinate = CLLocationCoordinate2D(latitude: pickupLocation.lat, longitude: pickupLocation.lng)
        pickupAnnotation.title = pickupAddress
        mapView.addAnnotationIfNotExist(pickupAnnotation)
        
        dropoffAnnotation.coordinate = CLLocationCoordinate2D(latitude: dropoffLocation.lat, longitude: dropoffLocation.lng)
        dropoffAnnotation.title = dropoffAddress
        mapView.addAnnotationIfNotExist(dropoffAnnotation)
        
        setUpdateVehicle(data.vehicleLocation)
        setStations(data.intermediateStopLocations)
    }
    
    func setStations(_ addressList: [Address?]) {
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
    
    func setBookingClosed() {
        isInRide = false
        showPopup(title: viewModel.rideFinishTitle)
    }

    func handleError(_ error: Error?) {
        isInRide = false
        viewModel.hideLoading()

        if let error = error as? WSError {
            showPopup(title: error.message)
        } else if let error = error {
            showPopup(title: error.localizedDescription)
        } else {
            showPopup(title: viewModel.errorTitle)
        }
    }
    
    func showPopup(title: String) {
        viewModel.showPopup(title: title) {
            if let popupView = UIApplication.topViewController() {
                popupView.dismiss(animated: true)
            }
        }
    }
}

// MARK: - Action
@objc
private extension HomeViewController {
    func socketAction() {
        viewModel.showLoading()
        isInRide ? viewModel.socketManager.disconnect() : viewModel.socketManager.connect()
    }
}
