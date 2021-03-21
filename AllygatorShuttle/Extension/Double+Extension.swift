//
//  Double+Extension.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 21.03.2021.
//

import Foundation

extension Double {
    func radians() -> Double {
        return self * .pi / 180.0
    }
    
    func degrees() -> Double {
        return self * 180 / .pi
    }
}
