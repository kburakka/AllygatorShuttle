//
//  LoadingHelper.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 20.03.2021.
//

import Foundation
import UIKit
import Lottie

public struct LoadingConfig {
    static var shadow: CGFloat = 0.7
    static var animationDuration: TimeInterval = 0.3
}

public final class LoadingHelper {
    
    private var maskView: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.isUserInteractionEnabled = false
        background.alpha = 0.0
        return background
    }()
    
    private var _lottie: AnimationView!
    
    public var contentMode: UIView.ContentMode = .scaleAspectFit {
        didSet {
            self._lottie.contentMode = contentMode
        }
    }
    
    public var size = CGSize(width: 200, height: 200)
    
    public init(_ name: String) {
        self._lottie = AnimationView(name: name)
        self._lottie.loopMode = .loop
        self._lottie.accessibilityIdentifier = "LoadingLottie"
    }
    
    public init(_ lottie: AnimationView) {
        self._lottie = lottie
    }
    
    public func showHUD(with delay: TimeInterval = 0.0) {
        _lottie.loopMode = .loop
        createHUD(delay: delay)
    }
    
    public func stopHUD() {
        clearHUD()
    }
    
    private func createHUD(delay: TimeInterval = 0.0) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow!.isUserInteractionEnabled = false
            self.configureMask()
            self.configureConstraints()
            UIView.animate(withDuration: LoadingConfig.animationDuration, delay: delay, options: .curveEaseIn, animations: {
                
                self.maskView.alpha = 1.0
            }, completion: nil)
            
            self._lottie.play(completion: { _ in
                self.clearHUD()
            })
        }
    }
    
    private func configureMask() {
        maskView.backgroundColor = UIColor.black.withAlphaComponent(LoadingConfig.shadow)
    }
    
    private func configureConstraints() {
        // Configure Backround View Constraints
        self.keyWindow.view.addSubview(self.maskView)
        
        guard let keyWindowMargins = keyWindow.view else { return }
        
        maskView.leadingAnchor.constraint(equalTo: keyWindowMargins.leadingAnchor, constant: 0).isActive = true
        maskView.trailingAnchor.constraint(equalTo: keyWindowMargins.trailingAnchor, constant: 0).isActive = true
        maskView.topAnchor.constraint(equalTo: keyWindowMargins.topAnchor).isActive = true
        maskView.bottomAnchor.constraint(equalTo: keyWindowMargins.bottomAnchor).isActive = true
        
        maskView.addSubview(_lottie)
        
        // Configure Lottie Constraints
        _lottie.translatesAutoresizingMaskIntoConstraints = false
        _lottie.centerXAnchor.constraint(equalTo: maskView.centerXAnchor, constant: 0).isActive = true
        _lottie.centerYAnchor.constraint(equalTo: maskView.centerYAnchor, constant: 0).isActive = true
        _lottie.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        _lottie.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    private func clearHUD() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: LoadingConfig.animationDuration, delay: 0, options: .curveEaseIn, animations: {
                self.maskView.alpha = 0.0
            }) { _ in
                UIApplication.shared.keyWindow!.isUserInteractionEnabled = true
                self.maskView.removeFromSuperview()
                self._lottie.stop()
            }
        }
    }
    
    private var keyWindow: UIViewController {
        return UIApplication.topViewController()!
    }
}
