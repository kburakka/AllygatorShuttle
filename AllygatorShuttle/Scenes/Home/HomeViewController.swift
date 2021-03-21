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
    var stationList: [BaseAnnotation] { get set }
    var vehicleAnnotationView: BaseAnnotationView? { get set }

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
    var vehicleAnnotation = BaseAnnotation(image: .imgVehicle, annotationType: .vehicle)
    var pickupAnnotation = BaseAnnotation(image: .imgStart, annotationType: .pickup)
    var dropoffAnnotation = BaseAnnotation(image: .imgFinish, annotationType: .dropoff)
    var vehicleAnnotationView: BaseAnnotationView?
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
        button.setTitle(viewModel.socketButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(socketAction), for: .touchUpInside)
        button.accessibilityIdentifier = "socketButton"
        return button
    }()
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .mavenProMediumXXLarge
        label.textColor = .coal
        label.accessibilityIdentifier = "statusLabel"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [statusLabel,
                                                       socketButton],
                                   axis: .vertical,
                                   spacing: 15,
                                   alignment: .center,
                                   distribution: .fill)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "HomeViewController"
        mapView.delegate = self
        
        viewModel.isInRideCompletion = { [weak self] isInRide in
            guard let self = self else { return }
            self.socketButton.setTitle(self.viewModel.socketButtonTitle, for: .normal)
            if !isInRide {
                self.viewModel.isFirstTimeVehicleUpdate = true
                self.statusLabel.text = nil
                self.mapView.removeAllAnnotations()
            }
        }

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

// MARK: - Helper
extension HomeViewController {
    func setWebSocket() {
        viewModel.socketManager.eventClosure = { event in
            guard let event = event else {
                self.viewModel.isInRide = false
                self.viewModel.hideLoading()
                self.showPopup(title: self.viewModel.errorTitle)
                return
            }
            switch event {
            case .connected:
                self.viewModel.isConectWebSocket = true
                self.viewModel.hideLoading()
            case .disconnected:
                self.viewModel.isConectWebSocket = false
                self.viewModel.hideLoading()
            case .text(let string):
                self.parseSocketEvent(socket: string)
            case .cancelled:
                self.viewModel.isInRide = false
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
            viewModel.isInRide = false
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
            statusLabel.text = viewModel.getStatusAlias(status: data)
        case .intermediateStopLocationsChanged(let data):
            setStations(data)
        case .bookingClosed:
            setBookingClosed()
        case .error:
            handleError(nil)
        }
    }
    
    func setUpdateVehicle(_ address: Address) {
        var address = address
        UIView.animate(withDuration: 2.0, animations: {
            let location = CLLocationCoordinate2D(latitude: address.lat, longitude: address.lng)
            self.vehicleAnnotation.coordinate = location
            address.setBearingAngle(lastAddress: self.viewModel.lastVehicleAddress)
            self.vehicleAnnotationView?.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(address.bearing ?? 0))
            self.viewModel.lastVehicleAddress = address
        })

        if viewModel.isFirstTimeVehicleUpdate {
            viewModel.isFirstTimeVehicleUpdate = false
            mapView.addAnnotationIfNotExist(vehicleAnnotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    func setBookingOpened(_ data: BookingOpenedData) {
        viewModel.isInRide = true
        statusLabel.text = viewModel.getStatusAlias(status: data.status)
        
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
                let stationAnnotation = BaseAnnotation(image: .imgStation, annotationType: .station)
                stationAnnotation.coordinate = CLLocationCoordinate2D(latitude: address.lat, longitude: address.lng)
                stationAnnotation.title = address.address
                mapView.addAnnotation(stationAnnotation)
                stationList.append(stationAnnotation)
            }
        })
    }
    
    func setBookingClosed() {
        viewModel.isInRide = false
        showPopup(title: viewModel.rideFinishTitle)
    }

    func handleError(_ error: Error?) {
        viewModel.isInRide = false
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
        viewModel.isPopupDisplay = true
        viewModel.showPopup(title: title) {
            self.viewModel.isPopupDisplay = false
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
        viewModel.isInRide ? viewModel.socketManager.disconnect() : viewModel.socketManager.connect()
    }
}

// MARK: - MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let baseAnnotation = annotation as? BaseAnnotation
        let annotationView = BaseAnnotationView(annotation: baseAnnotation, reuseIdentifier: "baseAnnotationView")
        annotationView.updateImge(image: baseAnnotation?.image)
        annotationView.canShowCallout = true
        if baseAnnotation?.annotationType == .vehicle {
            vehicleAnnotationView = annotationView
        }

        return annotationView
    }
}
