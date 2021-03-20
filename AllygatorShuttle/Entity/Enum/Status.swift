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
    
    func getAlias() -> String {
        switch self {
        case .waitingForPickup:
            return "Waiting for pickup!"
        case .inVehicle:
            return "In vehicle"
        case .droppedOff:
            return "Dropped off"
        }
    }
}
