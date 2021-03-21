//
//  SplashViewController.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import UIKit
import Starscream

final class SplashViewController: BaseViewController<SplashViewModel> {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.accessibilityIdentifier = "logoImageView"
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoImageView()
        view.accessibilityIdentifier = "SplashViewController"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel.showHomeScreen()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupViews() {
        view.addSubview(logoImageView)
    }
    
    override func setupLayouts() {
        logoImageView.aspectRatio(1766 / 226)
        logoImageView.leadingToSuperview(offset: 40.0)
        logoImageView.trailingToSuperview(offset: 40.0)
        logoImageView.centerInSuperview()
    }
}

// MARK: - Helper
extension SplashViewController {
    func setLogoImageView() {
        logoImageView.image = viewModel.logoImage
    }
}
