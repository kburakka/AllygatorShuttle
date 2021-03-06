//
//  SocketManager.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import Starscream

class SocketManager: WebSocketDelegate {
    static let shared = SocketManager()
    
    var socket: WebSocket?
    var eventClosure: EventClosure?
    
    func connect() {
        guard let url = URL(string: Constants.webSocketUrl)
        else {
            eventClosure?(nil)
            return
        }
        let request = URLRequest(url: url)
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    /// This triggers when new event arrives
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        eventClosure?(event)
    }
}
