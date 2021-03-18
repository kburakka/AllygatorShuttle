//
//  BookingOpenedData.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

struct BookingOpenedData: Decodable {
    let status: Status
    let vehicleLocation: Address
    let pickupLocation: Address
    let dropoffLocation: Address
    let intermediateStopLocations: [Address?]
}
