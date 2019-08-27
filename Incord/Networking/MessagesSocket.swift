//
//  MessagesSocket.swift
//  Incord
//
//  Created by Cole M on 8/27/19.
//  Copyright © 2019 Cole M. All rights reserved.
//

import Foundation

class MessagesSocket: NSObject {
    
    static let shared = MessagesSocket()
    var messages = [Message]()
    var message: Message?
    
    func addMessage(id: Int, avatar: String, username: String, Date: String, message: String, subChannelID: Int, createAccountID: UUID, completion: @escaping (Result<Message, Error>) -> ()) {
        let body = Message(id: id, avatar: avatar, username: username, date: Date, message: message, subChannelID: subChannelID, createAccountID: createAccountID)
        let json = try? JSONEncoder().encode(body)
        var request = URLRequest(url: URL(string: "\(WEBSOCKET_URL)/messages")!)
        request.timeoutInterval = 5
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let urlSession = URLSession(configuration: .default)
        let webSocketTask = urlSession.webSocketTask(with: request)
        webSocketTask.resume()
        let message = URLSessionWebSocketTask.Message.data(json!)
        webSocketTask.send(message) { (error) in
           if let error = error {
               print("WebSocket sending error: \(error)")
            }
            do {
                let message = try JSONDecoder().decode(Message.self, from: json!)
                completion(.success(message))
            } catch let err {
                completion(.failure(err))
            }
            webSocketTask.receive { (res) in
                switch res {
                case .failure(let error):
                    print("Failed to receive message:\(error)")
                case .success(let message):
                    switch message {
                    case .string(let string):
                        print("Received text message: \(string)")
                    case .data(let data):
                        print("Received binary data: \(data)")
                        let received = try? JSONDecoder().decode(Message.self, from: data)
                        guard let avatarString = received?.avatar else {return}
                        guard let usernameString = received?.username else {return}
                        guard let dateString = received?.date else {return}
                        guard let messageString = received?.message else {return}
                        guard let subchannelInt = received?.subChannelID else {return}
                        guard let messageInt = received?.id else {return}
                        guard let accountInt = received?.createAccountID else {return}
                        let saveMessages = Message(id: messageInt, avatar: avatarString, username: usernameString, date: dateString, message: messageString, subChannelID: subchannelInt, createAccountID: accountInt)
                        self.messages.append(saveMessages)
                        NotificationCenter.default.post(name: NEW_MESSAGE, object: nil)
                    @unknown default:
                        fatalError()
                    }
                }
            }
        }
    }
    
    func closeMessageConnection() {
        let urlSession = URLSession(configuration: .default)
        let webSocketTask = urlSession.webSocketTask(with: URL(string: "\(WEBSOCKET_URL)/messages")!)
        webSocketTask.cancel(with: .goingAway, reason: nil)
        print("closed message connection \(webSocketTask.closeCode)")
    }
}

