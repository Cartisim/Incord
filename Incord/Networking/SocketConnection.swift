//
//  SocketConnection.swift
//  Incord
//
//  Created by Cole M on 8/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

class SocketConnection: NSObject {
    
    static let shared = SocketConnection()

    func connectToSocket() {
        let urlSession = URLSession(configuration: .default)
        guard let url = URL(string: "ws://localhost:8080/api") else {return}
        let webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask.resume()
        let message = URLSessionWebSocketTask.Message.string("Sending")
        webSocketTask.send(message) { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
            }
        }
        webSocketTask.receive { (res) in
            switch res {
            case .success(let message):
                print(message)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func closeConnection() {
        let urlSession = URLSession(configuration: .default)
        let webSocketTask = urlSession.webSocketTask(with: URL(string: "\(WEBSOCKET_URL)")!)
        webSocketTask.cancel(with: .goingAway, reason: nil)
        print("closed connection \(webSocketTask.closeCode)")
    }
}
