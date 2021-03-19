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
    var eventClosure: EventClosure?
    
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
    
    func disconnect() {
        socket.disconnect()
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        eventClosure?(event)
    }
}
