//
//  UIView+Extension.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 19.03.2021.
//

import UIKit
 
extension UIView {
    convenience init(backgroundColor: UIColor?,
                     cornerRadius: CGFloat = 0.0) {
        self.init()
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
    
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
    
    func addShadow(ofColor color: UIColor = .black,
                   radius: CGFloat = 6,
                   offset: CGSize = .zero,
                   opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}
