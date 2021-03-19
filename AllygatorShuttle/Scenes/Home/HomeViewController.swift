//
//  HomeViewController.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 19.03.2021.
//

import UIKit
import MapKit

final class HomeViewController: BaseViewController<HomeViewModel> {
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                SocketManager.shared.connect()
    }
    
    override func setupViews() {
        view.addSubview(mapView)
    }
    
    override func setupLayouts() {
        mapView.edgesToSuperview()
    }
}
