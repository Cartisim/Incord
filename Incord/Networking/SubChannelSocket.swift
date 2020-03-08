//
//  SubChannelSocket.swift
//  Incord
//
//  Created by Cole M on 8/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

class SubChannelSocket: NSObject {
    
    static let shared = SubChannelSocket()
    var subchannels = [SubChannel]()
    var subchannel: SubChannel?
    
    func addSubChannel(id: Int, title: String, channelID: Int, completion: @escaping (Result<SubChannel, Error>) -> ()) {
        let body = SubChannel(id: id, title: title, channelID: channelID)
        let json = try? JSONEncoder().encode(body)
        var request = URLRequest(url: URL(string: "\(WEBSOCKET_URL)/sub_channel")!)
        request.timeoutInterval = 5
         request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(UserData.shared.token)", forHTTPHeaderField: "Authorization")

        let urlSession = URLSession(configuration: .default)
        let webSocketTask = urlSession.webSocketTask(with: request)
        webSocketTask.resume()
        let subChannel = URLSessionWebSocketTask.Message.data(json!)
        webSocketTask.send(subChannel) { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
            }
            do {
                let subChannel = try JSONDecoder().decode(SubChannel.self, from: json!)
                completion(.success(subChannel))
            } catch let error {
                completion(.failure(error))
            }
            webSocketTask.receive { (res) in
                switch res {
                case .failure(let error):
                    print("Failed to receive message: \(error)")
                case .success(let message):
                    switch message {
                    case .string(let text):
                        print("Received text message: \(text)")
                    case .data(let data):
                        print("Received binary message: \(data)")
                        let recevied = try? JSONDecoder().decode(SubChannel.self, from: data)
                        guard let subChannelName = recevied?.title else {return}
                        guard let channelId = recevied?.channelID else {return}
                        let subChannelId = recevied?.id
                        let subchannel = SubChannel(id: subChannelId, title: subChannelName, channelID: channelId)
                        self.subchannels.append(subchannel)
                          NotificationCenter.default.post(name: NEW_SUB_CHANNEL, object: nil)
                    @unknown default:
                        fatalError()
                    }
                }
            }
        }
    }
    
    func closeSubChannelConnection() {
        let urlSession = URLSession(configuration: .default)
        let webSocketTask = urlSession.webSocketTask(with: URL(string: "\(WEBSOCKET_URL)/sub_channel")!)
        webSocketTask.cancel(with: .goingAway, reason: nil)
        print("closed sub channel connection \(webSocketTask.closeCode)")
    }
}
