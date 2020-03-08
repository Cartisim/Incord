//
//  ChannelSocket.swift
//  Incord
//
//  Created by Cole M on 8/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

class ChannelSocket: NSObject {

static let shared = ChannelSocket()
var channels = [Channel]()
    
    func addChannel(id: Int, image: String, channelName: String, completion: @escaping (Result<Channel, Error>) -> ()) {
        
        let body = Channel(id: id, imageString: image, channel: channelName)
        let json = try? JSONEncoder().encode(body)
        var request = URLRequest(url: URL(string:"\(WEBSOCKET_URL)/channel")!)
        request.timeoutInterval = 5
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let urlSession = URLSession(configuration: .default)
        let webSocketTask = urlSession.webSocketTask(with: request)
        webSocketTask.resume()
        let channel = URLSessionWebSocketTask.Message.data(json!)
        webSocketTask.send(channel) {error in
            if let error = error {
                print("WebSocket sending error: \(error)")
            }
            do {
                let channel = try JSONDecoder().decode(Channel.self, from: json!)
                completion(.success(channel))
            } catch let error {
                completion(.failure(error))
            }

            webSocketTask.receive { res in
                switch res {
                case .failure(let error):
                    print("Failed to receive message: \(error)")
                case .success(let message):
                    switch message {
                    case .string(let text):
                        print("Received text message: \(text)")
                    case .data(let data):
                        print("Received binary message: \(data)")
                        let recevied = try? JSONDecoder().decode(Channel.self, from: data)
          
                        guard let channelName = recevied?.channel else {return}
                        guard let imageName = recevied?.imageString else {return}
                        guard let channelID = recevied?.id! else {return}
                        let channel = Channel(id: channelID, imageString: imageName, channel: channelName)
                        self.channels.append(channel)
                        NotificationCenter.default.post(name: NEW_CHANNEL, object: nil)
                    @unknown default:
                        fatalError()
                    }
                }
            }
        }
    }

    func closeChannelConnection() {
        let urlSession = URLSession(configuration: .default)
        let webSocketTask = urlSession.webSocketTask(with: URL(string: "\(WEBSOCKET_URL)/channel")!)
        webSocketTask.cancel(with: .goingAway, reason: nil)
        print("closed channel connection \(webSocketTask.closeCode)")
    }
}


