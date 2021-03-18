//
//  Event.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

enum Event: String, Decodable {
    case bookingOpened
    case vehicleLocationUpdated
    case statusUpdated
    case intermediateStopLocationsChanged
    case bookingClosed
}
