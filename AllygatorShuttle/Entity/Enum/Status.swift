//
//  Status.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

enum Status: String, Decodable {
    case waitingForPickup
    case inVehicle
    case droppedOff
}
