//
//  SocketData.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

enum SocketData: Decodable {
    case bookingOpenedData(BookingOpenedData)
    case vehicleLocationUpdated(Address)
    case statusUpdated(Status)
    case intermediateStopLocationsChanged([Address?])
    case bookingClosed
    
    init(from decoder: Decoder) throws {
        if let bookingOpenedData = try? decoder.singleValueContainer().decode(BookingOpenedData.self) {
            self = .bookingOpenedData(bookingOpenedData)
            return
        } else if let vehicleLocationUpdated = try? decoder.singleValueContainer().decode(Address.self) {
            self = .vehicleLocationUpdated(vehicleLocationUpdated)
            return
        } else if let statusUpdated = try? decoder.singleValueContainer().decode(Status.self) {
            self = .statusUpdated(statusUpdated)
            return
        } else if let intermediateStopLocationsChanged = try? decoder.singleValueContainer().decode([Address?].self) {
            self = .intermediateStopLocationsChanged(intermediateStopLocationsChanged)
            return
        } else if (try? decoder.singleValueContainer().decodeNil()) != nil {
            self = .bookingClosed
            return
        }
        
        throw QuantumError.missingValue
    }
    
    enum QuantumError: Error {
        case missingValue
    }
}
