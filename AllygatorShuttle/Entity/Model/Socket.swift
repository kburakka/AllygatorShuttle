//
//  Socket.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import Foundation

struct Socket: Decodable {
    let event: Event
    let data: SocketData
    
    init?(data: Data) {
        guard let decode = try? JSONDecoder().decode(Socket.self, from: data) else { return nil }
        self = decode
    }
}
