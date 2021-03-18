//
//  SocketManager.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import Starscream

class SocketManager: WebSocketDelegate {
    static let shared = SocketManager()
    
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    
    func connect() {
        guard let url = URL(string: Network.webSocketUrl)
        else {
            print("connection error")
            return
        }
        let request = URLRequest(url: url)
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            socket.disconnect()
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            parseSocketEvent(socket: string)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            print("ping")
        case .pong(_):
            print("pong")
        case .viabilityChanged(_):
            print("viabilityChanged")
        case .reconnectSuggested(_):
            print("reconnectSuggested")
        case .cancelled:
            print("cancelled")
            isConnected = false
        case .error(let error):
            print("error")
            isConnected = false
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    func parseSocketEvent(socket: String) {
        guard let data = socket.data(using: .utf8),
              let response = Socket(data: data) else {
            print("HATAAA")
            return
        }
        
        switch response.data {
        case .bookingOpenedData(let data):
            print(data.status)
        case .vehicleLocationUpdated(let data):
            print(data.lat)
        case .statusUpdated(let data):
            print(data.rawValue)
        case .intermediateStopLocationsChanged(let data):
            if let adress = data.first {
                print(adress?.lat)
            }
        case .bookingClosed(let data):
            print(data)
        case .none:
            print("boss")
        }
    }
}
