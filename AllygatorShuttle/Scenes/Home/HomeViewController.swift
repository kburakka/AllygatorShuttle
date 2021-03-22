//
//  HomeViewController.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 19.03.2021.
//

import UIKit
import MapKit
import Starscream

protocol HomeViewControllerDataProtocol {
    var mapView: MKMapView { get }
    var cardView: UIView { get }
    var socketButton: UIButton { get }
    var statusLabel: UILabel { get }
    var cardStackView: UIStackView { get }
    var buttonStackView: UIStackView { get }
    var vehicleAnnotation: BaseAnnotation { get }
    var pickupAnnotation: BaseAnnotation { get }
    var dropoffAnnotation: BaseAnnotation { get }
    var stationList: [BaseAnnotation] { get set }
    var vehicleAnnotationView: BaseAnnotationView? { get set }
    var detailViews: [DetailView] { get set }
}

protocol HomeViewControllerHelperProtocol {
    func setInRide()
    func setWebSocket()
    func parseSocketEvent(socket: String)
    func setUpdateVehicle(_ address: Address)
    func setBookingOpened(_ data: BookingOpenedData)
    func setStations(_ addressList: [Address?])
    func handleError(_ error: Error?)
    func showPopup(title: String)
    func setBookingClosed(popupTitle: String)
    func toggleDetailButton()
    func toggleDetailViews(isHidden: Bool)
}

final class HomeViewController: BaseViewController<HomeViewModel>, HomeViewControllerDataProtocol {
    var mapView = MKMapView()
    var vehicleAnnotation = BaseAnnotation(image: .imgVehicle, annotationType: .vehicle)
    var pickupAnnotation = BaseAnnotation(image: .imgStart, annotationType: .pickup)
    var dropoffAnnotation = BaseAnnotation(image: .imgFinish, annotationType: .dropoff)
    var vehicleAnnotationView: BaseAnnotationView?
    var stationList: [BaseAnnotation] = []
    var detailViews: [DetailView] = []
    
    let cardView: UIView = {
        let view = UIView(backgroundColor: .white, cornerRadius: 19)
        view.addShadow(radius: 14,
                       offset: CGSize(width: 0, height: -9),
                       opacity: 0.2)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.coal.cgColor
        return view
    }()
    
    lazy var socketButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 6
        button.height(44)
        button.width(120)
        button.titleLabel?.font = .mavenProMediumLarge
        button.backgroundColor = .coal
        button.titleLabel?.textColor = .calcite
        button.setTitle(viewModel.socketButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(socketAction), for: .touchUpInside)
        button.accessibilityIdentifier = "socketButton"
        return button
    }()
    
    lazy var detailButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 6
        button.height(44)
        button.width(120)
        button.titleLabel?.font = .mavenProMediumLarge
        button.backgroundColor = .atelier
        button.titleLabel?.textColor = .calcite
        button.setTitle(viewModel.detailButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(detailAction), for: .touchUpInside)
        button.accessibilityIdentifier = "detailButton"
        button.isHidden = true
        button.alpha = 0
        return button
    }()
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .mavenProMediumXXLarge
        label.textColor = .coal
        label.accessibilityIdentifier = "statusLabel"
        return label
    }()
    
    lazy var cardStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [detailStackView,
                                                       buttonStackView],
                                   axis: .vertical,
                                   spacing: 15,
                                   alignment: .center,
                                   distribution: .equalCentering)
        return stackView
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [socketButton, detailButton],
                                    axis: .horizontal,
                                    spacing: 15,
                                    alignment: .center,
                                    distribution: .fill)
        return stackView
    }()
    
    lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [statusLabel],
                                    axis: .vertical,
                                    spacing: 10,
                                    alignment: .center,
                                    distribution: .fill)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "HomeViewController"
        mapView.delegate = self
        setInRide()
        setWebSocket()
    }
    
    override func setupViews() {
        cardView.addSubview(cardStackView)
        view.addSubviews([mapView, cardView])
    }
    
    override func setupLayouts() {
        mapView.edgesToSuperview(excluding: .bottom)
        mapView.bottomToTop(of: cardView, offset: 20)
        
        cardStackView.edgesToSuperview(insets: .init(top: 20, left: 20, bottom: 50, right: 20))
        cardView.edgesToSuperview(excluding: .top,
                                  insets: .init(top: 0,
                                                left: 0,
                                                bottom: -20,
                                                right: 0),
                                  usingSafeArea: false)
    }
}

// MARK: - Helper
extension HomeViewController: HomeViewControllerHelperProtocol {
    func setInRide() {
        viewModel.isInRideCompletion = { [weak self] isInRide in
            guard let self = self else { return }
            self.socketButton.setTitle(self.viewModel.socketButtonTitle, for: .normal)
            if !isInRide {
                self.viewModel.isFirstTimeVehicleUpdate = true
                self.statusLabel.text = nil
                self.mapView.removeAllAnnotations()
            }
            self.toggleDetailButton()
        }
    }
    
    func setWebSocket() {
        viewModel.socketManager.eventClosure = { event in
            guard let event = event else {
                self.setBookingClosed(popupTitle: self.viewModel.errorTitle)
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
                self.setBookingClosed(popupTitle: self.viewModel.rideFinishTitle)
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
            setBookingClosed(popupTitle: viewModel.errorTitle)
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
            setBookingClosed(popupTitle: viewModel.rideFinishTitle)
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
    
    func setBookingClosed(popupTitle: String) {
        viewModel.hideLoading()
        toggleDetailViews(isHidden: true)
        viewModel.setDefaultModel()
        showPopup(title: popupTitle)
    }

    func handleError(_ error: Error?) {
        if let error = error as? WSError {
            setBookingClosed(popupTitle: error.message)
        } else if let error = error {
            setBookingClosed(popupTitle: error.localizedDescription)
        } else {
            setBookingClosed(popupTitle: viewModel.errorTitle)
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
    
    func toggleDetailButton() {
        UIView.animate(withDuration: 0.7, animations: {
            self.detailButton.isHidden = !self.viewModel.isInRide
            self.detailButton.alpha = !self.viewModel.isInRide ? 0 : 1
        })
    }
    
    func toggleDetailViews(isHidden: Bool) {
        UIView.animate(withDuration: 1, animations: {
            self.detailViews.forEach({
                $0.isHidden = isHidden
                $0.alpha = isHidden ? 0 : 1
            })
        }) { _ in
            if isHidden {
                self.detailViews.forEach({ $0.removeFromSuperview() })
                self.detailViews = []
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
    
    func detailAction() {
        if viewModel.isDetailDisplay {
            toggleDetailViews(isHidden: true)
        } else {
            let pickupDetailView = DetailView(type: .pickup, address: pickupAnnotation.title)
            pickupDetailView.accessibilityIdentifier = "pickupDetailView"
            detailViews.append(pickupDetailView)

            for station in stationList {
                let stationDetailView = DetailView(type: .station, address: station.title)
                detailViews.append(stationDetailView)

            }

            let dropoffDetailView = DetailView(type: .dropoff, address: dropoffAnnotation.title)
            dropoffDetailView.accessibilityIdentifier = "dropoffDetailView"
            detailViews.append(dropoffDetailView)
            detailViews.forEach({
                $0.isHidden = true
                $0.alpha = 0
            })
            
            detailStackView.addArrangedSubviews(detailViews)
            toggleDetailViews(isHidden: false)
        }
        
        viewModel.isDetailDisplay.toggle()
        detailButton.setTitle(viewModel.detailButtonTitle, for: .normal)
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
