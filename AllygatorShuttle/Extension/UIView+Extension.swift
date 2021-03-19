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
}
