//
//  Address.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import Foundation

struct Address: Decodable {
    let lat: Double
    let lng: Double
    let address: String?
    
    /// bearing for vehicle
    var bearing: Double?
    
    mutating func setBearingAngle(lastAddress: Address?) {
        guard let lastAddress = lastAddress else {
            bearing = nil
            return
        }

        let lat1 = lastAddress.lat.radians()
        let lng1 = lastAddress.lng.radians()

        let lat2 = self.lat.radians()
        let lng2 = self.lng.radians()
        
        let lngDifference = lng2 - lng1

        let vertical = sin(lngDifference) * cos(lat2)
        let horizontal = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lngDifference)
        bearing = atan2(vertical, horizontal)
    }
}
